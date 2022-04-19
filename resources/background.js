var username = "cdsqa";
var password = "Welcome1";
var retry = 3;

chrome.webRequest.onAuthRequired.addListener(
  function handler(details) {
    if (--retry < 0)
      return {cancel: true};
    return {authCredentials: {username: username, password: password}};
  },
  {urls: ["<all_urls>"]},
  ['blocking']
);

chrome.webRequest.onBeforeRequest.addListener(
	function(details) {
		console.log("blocking:", details.url);
		return {cancel: true };
	},
	{urls: ["*://*.ematicsolutions.com/*"]},
	["blocking"]
);