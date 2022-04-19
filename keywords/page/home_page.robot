***Variables***
&{home_page}
...     user_icon=xpath=//div[@class='panel wrapper']//a[@class='user_icon']
...     SignIn_link=xpath=//ul[@class='header links']//li[@class='authorization-link']

***Keywords***
Hover on user icon 
    common_keywords.Mouse over  ${home_page.user_icon}

Click on Sign In button
    common_keywords.Click Element  ${home_page.SignIn_link}