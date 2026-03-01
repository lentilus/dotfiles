#!/usr/bin/env python3
#
# Decrypt PGP/MIME messages
# 
# Modified 2026 lentilus <mail@lentilus.me>
# Copyright 2015 René Puls <rpuls@kcore.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import argparse
import datetime
import email
import email.generator
import email.message
import io
import os
import sys
import tempfile

import gpgme


VERSION = '1.0'


class PGPMimeError(Exception):
    pass

def decrypt_pgp_mime(msg, gpg_ctx, keep_original=True):
    if not (msg.get_content_type() == 'multipart/encrypted' and msg.get_param('protocol') == 'application/pgp-encrypted'):
        raise PGPMimeError('Not a PGP/MIME encrypted message')

    parts = msg.get_payload()
    if len(parts) != 2:
        raise PGPMimeError('PGP/MIME message has %d parts (expected 2)' % len(parts))

    control_part = parts[0]
    if control_part.get_content_type() != 'application/pgp-encrypted':
        raise PGPMimeError('First PGP/MIME subpart has type %s (expected application/pgp-encrypted)' % control_part.get_content_type())
    control_msg = email.message_from_string(control_part.get_payload())
    if control_msg['Version'] != '1':
        raise PGPMimeError('Unsupported PGP/MIME version %s (expected 1)' % control_msg['Version'])

    content_part = parts[1]
    if content_part.get_content_type() != 'application/octet-stream':
        raise PGPMimeError('Second PGP/MIME subpart has type %s (expected application/octet-stream)' % content_part.get_content_type())

    # Preserve the original message as an attachment
    original_msg = email.message.Message()
    original_msg.set_type('message/rfc822')
    original_msg.set_payload(msg.as_bytes())
    original_msg.add_header('Content-Disposition', 'attachment', filename='original')

    # Decrypt the message payload
    content_in = io.BytesIO(content_part.get_payload(decode=True))
    content_out = io.BytesIO()
    gpg_ctx.decrypt(content_in, content_out)

    content_bytes = content_out.getvalue()
    content_msg = email.message_from_bytes(content_bytes)

    if keep_original:
        msg.set_type('multipart/mixed')
        try:
            msg.del_param('protocol')
        except Exception:
            pass
        try:
            msg.del_param('boundary')
        except Exception:
            pass
        msg.add_header('X-Comment', 'Processed by pgpmime-decrypt %s %s' % (VERSION, datetime.datetime.now().isoformat()))
        msg.set_payload([content_msg, original_msg])
        return

    # replace encrypted container in-place with decrypted entity while preserving non-MIME top-level headers
    preserved = [(k, v) for k, v in msg.items() if not k.lower().startswith('content-') and k.lower() != 'mime-version']
    for h in list(msg.keys()):
        del msg[h]
    for k, v in preserved:
        msg[k] = v

    for k, v in content_msg.items():
        if k.lower().startswith('content-') or k.lower() == 'mime-version':
            msg[k] = v

    if content_msg.is_multipart():
        msg.set_payload([p for p in content_msg.get_payload()])
    else:
        raw = content_msg.get_payload(decode=True)
        if isinstance(raw, (bytes, bytearray)):
            msg.set_payload(raw)
        else:
            msg.set_payload(content_msg.get_payload())

    msg.add_header('X-Comment', 'Processed by pgpmime-decrypt %s %s' % (VERSION, datetime.datetime.now().isoformat()))


def main():
    parser = argparse.ArgumentParser(description='Decrypt PGP/MIME messages')
    parser.add_argument('--file', '-f', help='Operate on FILE in place')
    parser.add_argument('--keep-original', '-k', dest='keep_original', action='store_true', help='Keep original message as attachment')
    args = parser.parse_args()

    if args.file:
        with open(args.file, "rb") as fh:
            msg = email.message_from_binary_file(fh)
    else:
        msg = email.message_from_binary_file(sys.stdin.buffer)

    gpg_ctx = gpgme.Context()

    has_unixfrom = (msg.get_unixfrom() is not None)
    try:
        decrypt_pgp_mime(msg, gpg_ctx, keep_original=args.keep_original)
    except PGPMimeError as err:
        parser.exit(status=1, message='PGP/MIME error: %s\n' % err)
    except gpgme.GpgmeError as err:
        parser.exit(status=2, message='GPGME error: %s\n' % err)

    if args.file:
        tmp_dir = os.path.dirname(os.path.realpath(args.file))
        with tempfile.NamedTemporaryFile(dir=tmp_dir, delete=False) as tmp_fh:
            email.generator.BytesGenerator(tmp_fh).flatten(msg, unixfrom=has_unixfrom)
            os.replace(tmp_fh.name, args.file)
    else:
        email.generator.Generator(sys.stdout).flatten(msg, unixfrom=has_unixfrom)


if __name__ == '__main__':
    main()
