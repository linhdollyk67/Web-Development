*** Settings ***
Resource    ${CURDIR}/library.robot
Resource    ${CURDIR}/api_imports.robot

#keywords
Resource   ${CURDIR}/../keywords/common/common_keywords.robot
Resource   ${CURDIR}/../keywords/common/prepare.robot
Resource   ${CURDIR}/../keywords/features/login.robot
Resource   ${CURDIR}/../keywords/page/home_page.robot
Resource   ${CURDIR}/../keywords/page/login_page.robot

#resources
Variables   ${CURDIR}/../resources/env_configs.yaml
