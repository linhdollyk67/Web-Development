*** Keywords ***
Open desktop web browser
    CommonWebKeywords.Open Chrome Browser to page    ${LANGUAGE.lower()}
    ...    ${SELENIUMSPEED}
    ...    headless=${HEADLESS_FLAG}
    ...    extension_full_path=${CURDIR}/../../../resources/extension/${BU.lower()}/${ENV.lower()}
    ...    sleep_loading_extension=2

    Run Keyword If    '${BU.lower()}' == '${bu_type.rbs}'    common_desktop_keywords.Signin web authentication
    Run Keyword And Ignore Error    common_keywords.Add cookie for disable capcha
    Run Keyword And Ignore Error    home_common_page.Click close insider popup
    Run Keyword And Ignore Error    home_common_page.Click close popup
    Run Keyword If    '${BU.lower()}' == '${bu_type.rbs}'    common_keywords.Add cookie to turn on omni feature