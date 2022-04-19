***Keywords***
Open Chrome browser
    [Arguments]                     ${url}                         ${browser}
    Open Browser                    ${url}                         ${browser}
    Maximize Browser Window
    Set Browser Implicit Wait       10

Get Valid File Name
    [Arguments]    ${fname}
    ${valid_fname}     Evaluate    base64.urlsafe_b64encode($fname.decode('ascii')) if sys.version_info.major==2 else base64.urlsafe_b64encode($fname.encode('UTF-8'))    modules=sys,base64
    [Return]    ${valid_fname}

Test Teardown
    [Documentation]    All testcase always capture screenshot and all failed case always logs and returns the HTML source of the current page or frame.
    ${sc_fname}=    common_keywords.Get Valid File Name     ${TEST_NAME}
    ${status}    ${screenshot_path}    Run Keyword And Ignore Error    SeleniumLibrary.Capture Page Screenshot    ${sc_fname}_{index}.png
    Set Suite Variable    ${${TEST_NAME}}    ${screenshot_path}
    Run Keyword If Test Failed    Run Keyword And Ignore Error    SeleniumLibrary.Log Source

Keyword Teardown
    ${sc_fname}=    common_keywords.Get Valid File Name     ${TEST_NAME}
    Run Keyword And Ignore Error    SeleniumLibrary.Capture Page Screenshot    ${sc_fname}_{index}.png
    Run Keyword If  '${KEYWORD STATUS}'=='FAIL'   SeleniumLibrary.Log Source

Click Element
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${timeout} - <optional>
    ...    Make sure that ${GLOBALTIMEOUT} can be accessed globally
    [Arguments]    ${locator}    
    SeleniumLibrary.Wait Until Element Is Visible     ${locator}    
    SeleniumLibrary.Click Element  ${locator}

Verify Web Elements Are Visible
    [Documentation]    This keyword verify that page contains elements specified in arguments and verify each element is visible
    ...    ${elems}    - Varargs of locators or webelements
    [Arguments]     @{elems}
    SeleniumLibrary.Wait Until Page Contains Element    ${elems}[0]    
    FOR    ${elem}    IN    @{elems}
        SeleniumLibrary.Wait Until Element Is Visible    ${elem}    
    END

Mouse over
    [Arguments]     ${locator}
    common_keywords.Verify Web Elements Are Visible  ${locator}
    SeleniumLibrary.Mouse Over  ${locator}

Input Text And Verify Input For Web Element
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${text} - text to be verified
    [Arguments]     ${locator}      ${text}    ${retry}=3    ${duration}=10
    Wait Until Keyword Succeeds     ${retry} x    ${duration} sec    SeleniumLibrary.Page Should Contain Element    ${locator} 
    SeleniumLibrary.Clear Element Text    ${locator}
    SeleniumLibrary.Input Text     ${locator}    ${text}
    ${entered_text}=    SeleniumLibrary.Get Value    ${locator}
    Should Be Equal    '${entered_text}'    '${text}'