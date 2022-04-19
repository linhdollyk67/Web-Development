*** Setting ***
Library    Collections
Library    OperatingSystem
Library    ImageLibrary.py
Library    SeleniumWireLibrary.py
Library    SeleniumTestability.py
Library    BrowserMobProxyLibrary

*** Keywords ***
Click Element
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${timeout} - <optional>
    ...    Make sure that ${GLOBALTIMEOUT} can be accessed globally
    [Arguments]    ${locator}    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible     ${locator}    timeout=${timeout}
    SeleniumLibrary.Click Element  ${locator}

Double Click Element
    [Arguments]    ${locator}    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible     ${locator}    timeout=${timeout}
    SeleniumLibrary.Double Click Element  ${locator}

Verify Web Element Text Should Be Equal
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${expected_text} - text to be verified
    [Arguments]    ${locator}    ${expected_text}
    ${expected_text}=    Convert To String    ${expected_text}
    CommonWebKeywords.Verify Web Elements Are Visible    ${locator}
    SeleniumLibrary.Element Text Should Be    ${locator}    ${expected_text}

Verify Web Element Text Should Contain
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${expected_text} - text to be verified
    [Arguments]    ${locator}    ${expected_text}
    CommonWebKeywords.Verify Web Elements Are Visible    ${locator}
    SeleniumLibrary.Element Should Contain    ${locator}    ${expected_text}

Verify Web Element Text Should Start With
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${start_text} - text to be verified
    [Arguments]    ${locator}    ${start_text}
    CommonWebKeywords.Verify Web Elements Are Visible    ${locator}
    ${entered_text}=    SeleniumLibrary.Get Text    ${locator}
    Should Start With    ${entered_text}    ${start_text}

Input Text And Verify Input For Web Element
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${text} - text to be verified
    [Arguments]     ${locator}      ${text}    ${retry}=3    ${duration}=10
    Wait Until Keyword Succeeds     ${retry} x    ${duration} sec    SeleniumLibrary.Page Should Contain Element    ${locator} 
    SeleniumLibrary.Clear Element Text    ${locator}
    SeleniumLibrary.Input Text     ${locator}    ${text}
    ${entered_text}=    SeleniumLibrary.Get Value    ${locator}
    Should Be Equal    '${entered_text}'    '${text}'

Input Text And Retry Input Text For Element
    [Documentation]    This keyword that can input and retry input
    ...    ${text} - text to be verified
    [Arguments]     ${locator}      ${text}    ${retry}=5    ${duration}=5
    Wait Until Keyword Succeeds     ${retry} x    ${duration} sec    SeleniumLibrary.Page Should Contain Element    ${locator} 
    FOR     ${idx}    IN RANGE    ${retry}
        SeleniumLibrary.Clear Element Text    ${locator}
        SeleniumLibrary.Input Text     ${locator}    ${EMPTY}
        ${value}=    SeleniumLibrary.Get Value    ${locator}
        ${length}=    BuiltIn.Get Length     ${value}
        ${flag}=    BuiltIn.Run Keyword And Return Status    Should Be Equal As Numbers    ${length}    0
        Exit For Loop If    ${flag}
    END
    SeleniumLibrary.Input Text     ${locator}    ${text}
    ${entered_text}=    SeleniumLibrary.Get Value    ${locator}
    Should Be Equal    '${entered_text}'    '${text}'

Verify Web Elements Are Visible
    [Documentation]    This keyword verify that page contains elements specified in arguments and verify each element is visible
    ...    ${elems}    - Varargs of locators or webelements
    [Arguments]     @{elems}
    SeleniumLibrary.Wait Until Page Contains Element    ${elems}[0]    timeout=${GLOBALTIMEOUT}
    FOR    ${elem}    IN    @{elems}
        SeleniumLibrary.Wait Until Element Is Visible    ${elem}    timeout=${GLOBALTIMEOUT}
    END

Verify Web Elements Are Not Visible
    [Documentation]     Able to send argument as single variable or list variables
    [Arguments]     @{elems}
    FOR    ${elem}    IN    @{elems}
        SeleniumLibrary.Wait Until Element Is Not Visible    ${elem}     timeout=${GLOBALTIMEOUT}
    END

Verify Web Element Attribute Value Is Correctly
    [Arguments]    ${locator}    ${attribute}    ${value}
    CommonWebKeywords.Verify Web Elements Are Visible    ${locator}
    SeleniumLibrary.Element Attribute Value Should Be    ${locator}    ${attribute}    ${value}

Test Teardown
    [Documentation]    All testcase always capture screenshot and all failed case always logs and returns the HTML source of the current page or frame.
    ${sc_fname}=    CommonKeywords.Get Valid File Name     ${TEST_NAME}
    ${status}    ${screenshot_path}    Run Keyword And Ignore Error    SeleniumLibrary.Capture Page Screenshot    ${sc_fname}_{index}.png
    Set Suite Variable    ${${TEST_NAME}}    ${screenshot_path}
    Run Keyword If Test Failed    Run Keyword And Ignore Error    SeleniumLibrary.Log Source

Keyword Teardown
    ${sc_fname}=    CommonKeywords.Get Valid File Name     ${TEST_NAME}
    Run Keyword And Ignore Error    SeleniumLibrary.Capture Page Screenshot    ${sc_fname}_{index}.png
    Run Keyword If  '${KEYWORD STATUS}'=='FAIL'   SeleniumLibrary.Log Source

Open Chrome Browser to page
    [Documentation]     ${speed} variable is able to set via Global variable or use default by Name argument
    [Arguments]     ${url}    ${speed}=0.3    ${headless}=${False}    ${extension_full_path}=${EMPTY}    ${sleep_loading_extension}=0
    ${options}=     Evaluate     sys.modules['selenium.webdriver'].ChromeOptions()     sys
    Call Method     ${options}     add_argument     --disable-infobars
    Call Method     ${options}     add_argument     --window-size\=1366,768
    ${os}=  Evaluate    platform.system()       platform
    Run Keyword If    '${os}'.lower()=='linux'      Run Keywords    Call Method     ${options}     add_argument     --disable-dev-shm-usage
    ...     AND     Call Method     ${options}     add_argument     --disable-gpu
    ...     AND     Call Method     ${options}     add_argument     --no-sandbox
    ...     AND     Call Method     ${options}     add_argument     --disable-popup-blocking
    Run Keyword If    $extension_full_path!=''     Call Method    ${options}    add_argument   --load-extension\=${extension_full_path}
    Run Keyword If    '${headless}'.lower()=='true'    Call Method     ${options}     add_argument     --headless
    SeleniumLibrary.Create WebDriver     Chrome      chrome_options=${options}
    Sleep     ${sleep_loading_extension}s
    SeleniumLibrary.Go To     ${url}
    SeleniumLibrary.Set Selenium Speed     ${speed}

Open Browser to page
    [Documentation]    Make sure that ${browser} can be accessed globally
    [Arguments]     ${url}    ${speed}=0.3
    Run Keyword If     '${browser.lower()}'=='chrome'     Open Chrome Browser to page     ${url}    ${speed}

Open Chrome Browser to page on devices
    [Documentation]     ${deveices_browser} would be responsive devices in browser inspect
    [Arguments]     ${url}     ${devices_browser}    ${speed}=0.3    ${headless}=${False}    ${extension_full_path}=${EMPTY}    ${sleep_loading_extension}=0
    ${mobile_emulation}=    Create Dictionary    deviceName=${devices_browser}
    ${options}=     Evaluate     sys.modules['selenium.webdriver'].ChromeOptions()     sys
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    Call Method     ${options}     add_argument     --disable-infobars
    ${os}=  Evaluate    platform.system()       platform
    Run Keyword If    '${os}'.lower()=='linux'      Run Keywords    Call Method     ${options}     add_argument     --disable-dev-shm-usage
    ...     AND     Call Method     ${options}     add_argument     --disable-gpu
    ...     AND     Call Method     ${options}     add_argument     --no-sandbox
    ...     AND     Call Method     ${options}     add_argument     --disable-popup-blocking
    Run Keyword If    $extension_full_path!=''     Call Method    ${options}    add_argument   --load-extension\=${extension_full_path}
    Run Keyword If    '${headless}'.lower()=='true'    Call Method     ${options}     add_argument     --headless
    SeleniumLibrary.Create WebDriver     Chrome      chrome_options=${options}
    Sleep     ${sleep_loading_extension}s
    SeleniumLibrary.Go To     ${url}
    SeleniumLibrary.Set Selenium Speed    ${speed}

Open Chrome Browser to page on devices with proxy
    [Documentation]     ${devices_browser} would be responsive devices in browser inspect.
    ...    Using proxy to catch network layer.
    ...    Default port of proxy is 8081.
    ...    If you run on local, you have to use command 'pkill java' on terminal after finished test
    [Arguments]     ${url}     ${devices_browser}    ${speed}=0.3    ${headless}=${False}    ${extension_full_path}=${EMPTY}    ${sleep_loading_extension}=0
    ${mobile_emulation}=    Create Dictionary    deviceName=${devices_browser}
    ${proxy_options}=    Create Dictionary    trustAllServers=True
    BrowserMobProxyLibrary.Start Local Server     ${CURDIR}/../qa-common/browsermob-proxy-2.1.4/bin/browsermob-proxy    ${proxy_options}
    Create Proxy
    ${options}=     Evaluate     sys.modules['selenium.webdriver'].ChromeOptions()     sys
    Call Method     ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    Call Method     ${options}    add_argument    --disable-infobars
    Call Method     ${options}    add_argument    --proxy-server\=http://localhost:8081
    Call Method     ${options}    add_argument    --ignore-certificate-errors
    Call Method     ${options}    add_argument    --allow-insecure-localhost
    ${os}=  Evaluate    platform.system()       platform
    Run Keyword If    '${os}'.lower()=='linux'      Run Keywords    Call Method     ${options}     add_argument     --disable-dev-shm-usage
    ...     AND     Call Method     ${options}     add_argument     --disable-gpu
    ...     AND     Call Method     ${options}     add_argument     --no-sandbox
    ...     AND     Call Method     ${options}     add_argument     --disable-popup-blocking
    Run Keyword If    $extension_full_path!=''     Call Method    ${options}    add_argument   --load-extension\=${extension_full_path}
    Run Keyword If    '${headless}'.lower()=='true'    Call Method     ${options}     add_argument     --headless
    SeleniumLibrary.Create WebDriver     Chrome      chrome_options=${options}
    Sleep     ${sleep_loading_extension}s
    BrowserMobProxyLibrary.New Har    mob_proxy
    SeleniumLibrary.Go To     ${url}
    SeleniumLibrary.Set Selenium Speed    ${speed}

Close browsers with proxy
    [Documentation]    Using this keyword require open browser with common_responsive_keywords.Open responsive web browser with proxy keyword
    SeleniumLibrary.Close All Browsers
    BrowserMobProxyLibrary.Stop Local Server

Get har as json from proxy
    [Documentation]    Using this keyword require open browser with common_responsive_keywords.Open responsive web browser with proxy keyword
    ${har}=    BrowserMobProxyLibrary.Get Har As JSON
    ${mob_proxy_str}    JSONLibrary.Convert Json To String    ${har}
    [Return]    ${mob_proxy_str}

Scroll To Element
    [Documentation]    Scroll to element using javascript function 'scrollIntoView'
    ...                ${block} defines of vertical align (start, end, center, nearest)
    ...                Make sure that ${GLOBALTIMEOUT} can be accessed globally
    [Arguments]    ${locator}    ${block}=center    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Page Contains Element    ${locator}    ${timeout}
    ${elem}=    SeleniumLibrary.Get Webelements    ${locator}
    ${s2l}=    Get Library Instance    SeleniumLibrary
    ${driver}     Evaluate    $s2l._current_browser() if "_current_browser" in dir($s2l) else $s2l._drivers.current
    Run Keyword If    '${browserName.lower()}'=='safari'    Call Method    ${driver}    execute_script    arguments[0].scrollIntoViewIfNeeded();    ${elem}[0]
    ...    ELSE    Call Method    ${driver}    execute_script    arguments[0].scrollIntoView({block: "${block}"});    ${elem}[0]

Scroll To Position Page
    [Documentation]    Scroll to position with x(left-right) and y(top-down)
    [Arguments]    ${x}    ${y}
    Execute Javascript    window.scrollTo(${x}, ${y})

Scroll And Click Element
    [Documentation]    Scroll to element using javascript function 'scrollIntoView' and click an element
    [Arguments]    ${locator}
    Scroll To Element    ${locator}    
    CommonWebKeywords.Click Element    ${locator}

Scroll And Click Element Using Javascript
    [Documentation]    Scroll to element using javascript function 'scrollIntoView' and click an element
    [Arguments]    ${locator}
    Scroll To Element    ${locator}    
    Click Element Using Javascript  ${locator}

Click Element Using Javascript
    [Documentation]    click element using javascript function 'click'
    [Arguments]    ${locator}
    ${elem}=    SeleniumLibrary.Get Web Elements    ${locator}
    ${s2l}=    Get Library Instance    SeleniumLibrary
    ${driver}     Evaluate    $s2l._current_browser() if "_current_browser" in dir($s2l) else $s2l._drivers.current
    Call Method    ${driver}    execute_script    arguments[0].click();    ${elem}[0]

Mouse over
    [Arguments]     ${locator}
    Verify Web Elements Are Visible   ${locator}
    SeleniumLibrary.Mouse Over  ${locator}

Select dropdownlist by label
    [Arguments]     ${locator}     ${label}    ${retry}=3    ${duration}=10
    Verify Web Elements Are Visible   ${locator}
    Wait Until Keyword Succeeds     ${retry} x    ${duration} sec     SeleniumLibrary.Select From List By Label   ${locator}     ${label}

Select dropdownlist by value
    [Arguments]     ${locator}     ${value}    ${retry}=3    ${duration}=10
    Verify Web Elements Are Visible   ${locator}
    Wait Until Keyword Succeeds     ${retry} x    ${duration} sec     SeleniumLibrary.Select From List By Value   ${locator}     ${value}

Select dropdownlist by index
    [Arguments]     ${locator}     ${index}    ${retry}=3    ${duration}=10
    Verify Web Elements Are Visible   ${locator}
    Wait Until Keyword Succeeds     ${retry} x    ${duration} sec     SeleniumLibrary.Select From List By Index   ${locator}     ${index}

Mouse over to locator 1 and Click on locator 2
    [Arguments]     ${locator_1}     ${locator_2}
    ${library}=    Get Library Instance    SeleniumLibrary
    ${ac}=      Evaluate    selenium.webdriver.common.action_chains.ActionChains($library._current_browser())    modules=selenium, selenium.webdriver.common.action_chains
    ${elem_1}=    Get WebElement    ${locator_1}
    Verify Web Elements Are Visible   ${locator_2}
    ${elem_2}=    Get WebElement    ${locator_2}
    ${status}=    Evaluate    $ac.move_to_element($elem_1).move_to_element($elem_2).click($elem_2).perform()     modules=selenium, selenium.webdriver.common.action_chains

Image Should Be Visible On The Page
    [Arguments]    ${abs_image_path}    ${threshold}=0.8    ${result_dest_dir}=${None}
    ${page_image}=    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}${/}${SUITE_NAME}_${TEST_NAME}_{index}.png
    ${matches}=    ImageLibrary.Find Subimage In Image    ${abs_image_path}    ${page_image}     threshold=${threshold}    result=${result_dest_dir}
    BuiltIn.Should Not Be Empty    ${matches}

Click On Image
    [Arguments]    ${abs_image_path}    ${elem_index}=0    ${threshold}=0.8
    ${page_image}=    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}${/}${SUITE_NAME}_${TEST_NAME}_{index}.png
    ${matches}=    ImageLibrary.Find Subimage In Image    ${abs_image_path}    ${page_image}     threshold=${threshold}
    ${width}    ${height}=    ImageLibrary.Get Image Dimension    ${abs_image_path}
    BuiltIn.Should Not Be Empty    ${matches}
    ${coord}=    Collections.Get From List    ${matches}    ${elem_index}
    ${xoffset}=    BuiltIn.Set Variable    ${${coord}[0]+${width}/2}
    ${yoffset}=    BuiltIn.Set Variable    ${${coord}[1]+${height}/2}
    SeleniumLibrary.Click Element At Coordinates    body    ${xoffset}    ${yoffset}

Get Web Element CSS Property Value
    [Arguments]    ${locator}    ${property}
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}
    ${css}=    SeleniumLibrary.Get WebElement    ${locator}
    ${value}=    Call Method    ${css}    value_of_css_property    ${property}
    [Return]    ${value}

Scroll to top page
    Execute Javascript    window.scrollTo(document.body.scrollHeight,0)

Scroll to bottom page
    Execute Javascript    window.scrollTo(0,document.body.scrollHeight)

Scroll To Center Page
    Execute Javascript    window.scrollTo(0,document.body.scrollHeight/2)

Modify Response
    [Documentation]    This is a keyword for modify response.
    ...                ${url} variable is a URL Filtering by regular expression. e.g. .*staging.*tops.*
    ...                ${json_path} variable query path by json, e.g. $..name
    ...                ${new_value} variable is a new value for Modifying Response Value.
    [Arguments]    ${url}    ${json_path}    ${new_value}
    ${rule_index}=    SeleniumWireLibrary.Set Response Modifier    ${url}    ${json_path}    ${new_value}
    [Return]    ${rule_index}

Open Chrome Browser and Modify Response
    [Documentation]     ${speed} variable is able to set via Global variable or use default by Name argument
    ...                 ${modify_response} use Set Response Modifier keyword before and set this to be ${True} for Modifying Response.
    ...                 ${match_url} variable is a URL Filtering for adding authentication by regular expression.
    ...                 ${auth_username} is a authentication username.
    ...                 ${auth_password} is a authentication password.
    ...                 e.g. Modifying Response    https://staging.tops.co.th/th/   $..name    foo
    ...                      Open Chrome Browser and Modify Response    https://staging.tops.co.th/    .*staging.*tops.*    tops    Zxcv1234!    modify_response=${True}
    [Arguments]     ${url}    ${match_url}    ${auth_username}    ${auth_password}    ${headless}=${False}    ${speed}=0.3    ${extension_full_path}=${EMPTY}    ${sleep_loading_extension}=0
    ...    ${modify_response}=${False}
    ${options}=     Evaluate     sys.modules['selenium.webdriver'].ChromeOptions()     sys
    Call Method     ${options}     add_argument     --disable-infobars
    Call Method     ${options}     add_argument     --window-size\=1366,768
    ${os}=  Evaluate    platform.system()       platform
    Run Keyword If    '${os}'.lower()=='linux'      Run Keywords    Call Method     ${options}     add_argument     --disable-dev-shm-usage
    ...     AND     Call Method     ${options}     add_argument     --disable-gpu
    ...     AND     Call Method     ${options}     add_argument     --no-sandbox
    ...     AND     Call Method     ${options}     add_argument     --disable-dev-shm-usage
    Run Keyword If    $extension_full_path!=''     Call Method    ${options}    add_argument   --load-extension\=${extension_full_path}
    Run Keyword If    '${headless}'.lower()=='true'    Call Method     ${options}     add_argument     --headless
    SeleniumWireLibrary.Open Browser     ${url}    chrome     ${match_url}    ${auth_username}    ${auth_password}    seleniumwire_options=${modify_response}    chrome_options=${options}
    SeleniumLibrary.Set Selenium Speed     ${speed}

Modify Request Header
    [Documentation]    This is a keyword for modify request header, need to set before go to next page.
    ...                ${modify_request} should be a dictionary type.
    ...                e.g.    Modify Request Header    https://staging.tops.co.th/    foo=bar
    ...                        SeleniumLibrary.Go To    https://staging.tops.co.th/
    [Arguments]    ${url}    &{modify_request}
    Modify Request    ${url}    &{modify_request}

Get Requests Log
    ${current_request}=    SeleniumWireLibrary.Get Current Request
    [Return]    ${current_request}

Clear Requests Log
    SeleniumWireLibrary.Clear Request
    [Return]    ${current_request}

Wait Request
    [Arguments]    ${url}
    SeleniumWireLibrary.Wait For Request    ${url}

Modify Scopes Of Request Log
    [Documentation]    ${match_url} should be list of regex urls 
    ...    eg. ['.*stackoverflow.*', '.*github.*']
    [Arguments]    ${match_url}
    SeleniumWireLibrary.Scopes Request    ${match_url}

Remove Response Modifier By index
    [Documentation]    This is a keyword for response rules removing by index,
    ...                that is returned by keyword Set Modifying Response.
    [Arguments]    ${rule_index}=${None}
    SeleniumWireLibrary.Remove Response Modifier    ${rule_index}

Clear Modify Request Rules
    SeleniumWireLibrary.Clear Modify Request Rules

Clear Rewrite Rules 
    SeleniumWireLibrary.Clear Rewrite Rules

Trigger Change Event To Element
    [Arguments]    ${locator}
    ${locator}=    SeleniumLibrary.Get WebElement    ${locator}
    ${content}=    Get File  ${CURDIR}/elementTrigger.js
    ${s2l}=    Get Library Instance    SeleniumLibrary
    ${driver}     Evaluate    $s2l._current_browser() if "_current_browser" in dir($s2l) else $s2l._drivers.current
    Evaluate    $driver.execute_script($content)
    ${reactChangeExist}     Evaluate     $driver.execute_script("window.reactTriggerChange(arguments[0]);",$locator)

Input Text with Change Event And Verify Input For Web Element
    [Documentation]    ${locator} - could be any selenium locator and webelement object
    ...    ${text} - text to be verified
    [Arguments]     ${locator}      ${text}
    SeleniumLibrary.Input Text     ${locator}    ${text}
    Trigger Change Event To Element    ${locator}
    ${entered_text}=    SeleniumLibrary.Get Value    ${locator}
    Should Be Equal    '${entered_text}'    '${text}'

Set Element Attribute Value
    [Arguments]    ${locator}    ${value}
    SeleniumLibrary.Wait Until Page Contains Element    ${locator}
    ${elem}=    SeleniumLibrary.Get Web Elements    ${locator}
    ${s2l}=    Get Library Instance    SeleniumLibrary
    ${driver}     Evaluate    $s2l._current_browser() if "_current_browser" in dir($s2l) else $s2l._drivers.current
    Call Method    ${driver}    execute_script    arguments[0].value\="${value}";    ${elem}[0]

Accept Alert Popup
    [Arguments]    ${timeout}=${GLOBALTIMEOUT}
    Handle Alert    action=ACCEPT    timeout=${timeout}

Dismiss Alert Popup
    [Arguments]    ${timeout}=${GLOBALTIMEOUT}
    Handle Alert    action=DISMISS    timeout=${timeout}

Get Element Text
    [Arguments]    ${locator}
    Verify Web Elements Are Visible    ${locator}
    ${text}    SeleniumLibrary.Get Text    ${locator}
    [Return]    ${text}