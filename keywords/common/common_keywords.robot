*** Keywords ***
Open web browser with specific URL path
    [Arguments]    ${URL_path}
    Run Keyword If    '${TEST_PLATFORM}'=='${common_test_platform.responsive}'    Open responsive web browser with specific URL path    ${URL_path}
    ...    ELSE    Open desktop web browser with specific URL path    ${URL_path}

Wait until page is completely loaded
    SeleniumLibrary.Instrument Browser
    SeleniumLibrary.Wait For Testability Ready

Add cookie for disable capcha
    SeleniumLibrary.Add Cookie    tokenCaptcha    centralfrontend

Add cookie to turn on omni feature
    SeleniumLibrary.Delete Cookie    _gaexp
    SeleniumLibrary.Add Cookie    _gaexp    GAX1.3.UBTA_e5wRBGGQsmceiWB5Q.18663.1

Get cookie value from browser
    [Arguments]    ${name}
    ${cookie_object}=    SeleniumLibrary.Get Cookie    ${name}
    [Return]    ${cookie_object.value}

Verify Experiment Id From Cookies
    [Documentation]    This keyword will verify cookie ga_exp value that match with our argument or not
    ...                After matched it will return value from last index - eg. 0 [disable] , 1 [enable]
    ...                If it not matched , return ${False} value
    [Arguments]    ${ga_exp}    ${default_exp}
    ${ga_cookie}=    SeleniumLibrary.Get Cookie    _gaexp
    ${exp_result}=    String.Get Regexp Matches    ${ga_cookie.value}    ${ga_exp}.\\d*.\\d
    ${exp_count}=    Get Length    ${exp_result}
    Set Test Variable    ${ga_exp}    ${default_exp}
    Return From Keyword If    '${exp_count}'<'1'    ${False}
    ${value}=    String.Get Substring    ${exp_result}[0]    -1
    Set Test Variable    ${ga_exp}    ${value}

Select new window
    SeleniumLibrary.Switch Window    locator=NEW    timeout=${GLOBALTIMEOUT}

Select main window
    SeleniumLibrary.Switch Window    locator=MAIN    timeout=${GLOBALTIMEOUT}

Scroll down to fetch data until element is contained in page
    [Documentation]    Use For Loop to scroll with height until element is fetched and contained in page, this is to support lazy load
    ...    pageHeight-(scrollLength*index)
    [Arguments]    ${locator}
    ${section}=    Set Variable    ${10}
    ${page_height}=    SeleniumLibrary.Get Element Size    ${dict_home_page}[lbl_homepage]
    ${page_height}=    Set Variable    ${page_height}[1]
    ${scroll_length}=    Evaluate    '${page_height}/${section}'
    FOR    ${index}    IN RANGE    ${section}
        SeleniumLibrary.Execute Javascript    window.scrollTo(0, ${${page_height}-${${scroll_length}*${index}}})
        ${status}=    Run Keyword And Return Status    SeleniumLibrary.Wait Until Page Contains Element    ${locator}    timeout=10
        Return From Keyword If  '${status}' == '${true}'
    END
    Fail    This element cannot be found in this page.

Go to direct url
    [Arguments]    ${path}
    SeleniumLibrary.Go To    ${${BU.lower()}_url}/${language}/${path}
    Wait until page is completely loaded

Go to RBS landing page
    SeleniumLibrary.Go To    https://${ENV.lower()}.robinson.co.th/${LANGUAGE.lower()}

Click on search box
   CommonWebKeywords.Click Element     ${dict_pdp_page}[search_box]

Remove text value
    ${search_value}=    Get Value    ${dict_pdp_page}[search_box]
    ${length}=    Get Length    ${search_value}
    Run Keyword If    ${length}!=0    CommonWebKeywords.Click Element    ${dict_pdp_page}[btn_x_on_search_box]

Input text into search box
    [Arguments]    ${text}
    CommonWebKeywords.Click Element    ${dict_pdp_page}[search_box]
    CommonWebKeywords.Input Text And Verify Input For Web Element    ${dict_pdp_page}[search_box]    ${text}

Press Enter key to search a product
    SeleniumLibrary.Press Keys    None    RETURN

Select product in search box popup
    [Arguments]    ${product}
    ${product_locator}=    CommonKeywords.Format Text    ${dict_home_page}[lbl_product_list]     $product=${product}
    CommonWebKeywords.Click Element     ${product_locator}

Verify url pattern
    [Documentation]    Replace url pattern with a dictionary based on given items
    [Arguments]    ${expected_pattern}    ${dict_replace_pattern}
    FOR    ${key}    ${value}    IN    &{dict_replace_pattern}
        ${expected_pattern}=    Replace String    ${expected_pattern}    ${key}    ${value}
    END
    ${current_url}    SeleniumLibrary.Get Location
    Should Be Equal     ${current_url}    ${${BU.lower()}_url}${expected_pattern}

Genarate random key value parameters
    [Arguments]     ${number_of_characters}    ${number_of_numbers}
    ${current_url}    SeleniumLibrary.Get Location
    ${random_character}    String.Generate Random String    ${number_of_characters}    [LETTERS]
    ${random_number}    String.Generate Random String    ${number_of_numbers}    [NUMBERS]
    ${url_with_invalid_parameter}    Set Variable    ${current_url}/?${random_character}=${random_number}
    [Return]    ${url_with_invalid_parameter}