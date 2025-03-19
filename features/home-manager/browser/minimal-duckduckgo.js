(function() {
    'use strict';

    function cleanResults() {
        let resultsContainer = document.querySelector(".results");

        if (resultsContainer) {
            // Clear everything
            document.body.innerHTML = "";
            document.body.style.backgroundColor = "#121212"; // Dark background
            document.body.style.color = "#E0E0E0"; // Light text
            document.body.style.fontFamily = "Arial, sans-serif";

            // Create a new wrapper for cleaner results
            let wrapper = document.createElement("div");
            wrapper.style.marginLeft = "4%";  // Add left margin for better readability
            wrapper.style.maxWidth = "95%";   // Keep content centered and readable
            wrapper.style.paddingTop = "20px"; // Space below the banner
            document.body.appendChild(wrapper);

            // Extract and simplify results
            let results = resultsContainer.querySelectorAll(".result");
            results.forEach(result => {
                let titleElement = result.querySelector("h2 a");
                let linkElement = result.querySelector("h2 a");
                let snippetElement = result.querySelector(".result__snippet");
                let urlElement = result.querySelector(".result__url");

                if (titleElement && linkElement && urlElement) {
                    let resultDiv = document.createElement("div");
                    resultDiv.style.padding = "10px";
                    resultDiv.style.borderBottom = "1px solid #333"; // Darker divider
                    resultDiv.style.backgroundColor = "#1E1E1E"; // Darker result background
                    resultDiv.style.borderRadius = "5px";
                    resultDiv.style.marginBottom = "10px";

                    // Title
                    let title = document.createElement("a");
                    title.href = linkElement.href;
                    title.textContent = titleElement.textContent;
                    title.style.fontSize = "16px";
                    title.style.textDecoration = "none";
                    title.style.display = "block";
                    title.style.color = "#BBBBBB"; // Light blue title
                    title.style.fontWeight = "bold";

                    // Extract cleaned URL text
                    let cleanUrl = urlElement.textContent.trim();

                    // Display cleaned URL
                    let urlDisplay = document.createElement("small");
                    urlDisplay.textContent = cleanUrl;
                    urlDisplay.style.color = "#34A853"; // Green URL
                    urlDisplay.style.display = "block";
                    urlDisplay.style.fontSize = "13px";

                    // Summary (if available)
                    let summary = document.createElement("p");
                    summary.textContent = snippetElement ? snippetElement.textContent : "";
                    summary.style.fontSize = "13px";
                    summary.style.color = "#BBBBBB"; // Light gray text

                    resultDiv.appendChild(title);
                    resultDiv.appendChild(urlDisplay);
                    resultDiv.appendChild(summary);
                    wrapper.appendChild(resultDiv);
                }
            });
        }
    }

    function waitForResults() {
        let checkExist = setInterval(() => {
            if (document.querySelector(".results")) {
                clearInterval(checkExist);
                cleanResults();
            }
        }, 100); // Check every 12ms
    }

    // Run cleanup when the page loads
    window.addEventListener("load", waitForResults);

    // Observe dynamic content changes
    const observer = new MutationObserver(waitForResults);
    observer.observe(document.body, { childList: true, subtree: true });
})();
