*** Settings ***
Resource        ${CURDIR}/../../../imports/web_imports.robot
Test Setup      common_keywords.Open Chrome browser  ${asia_url}  ${chrome_browser}
Test Teardown   Run Keywords    common_keywords.Test Teardown    AND   SeleniumLibrary.Close Browser

**Test Cases***
Just for test 
    [Tags]  tc01
    login.Login by email, password successfully     quachh@science.regn.net     hien@2345