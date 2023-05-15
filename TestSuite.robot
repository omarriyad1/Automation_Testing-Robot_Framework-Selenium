*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${first_result}    ${EMPTY}
${TopOne}         ${EMPTY}
${Title}          ${EMPTY}
@{User-Rating}
@{Original_Rates}
${user-rate}      ${EMPTY}
${rate_attr}      ${EMPTY}
@{copied_rates}
@{results_related}
${result}         ${EMPTY}
${result_attr}    ${EMPTY}
@{Fresults}
${imdb-rates}     ${EMPTY}
@{Original_ones}
${ratee}          ${EMPTY}
${rateatr}        ${EMPTY}
${length}         250

*** Test Cases ***
Scenario_1
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Input Text    name=q    The Shawshank Redemption
    click button    id=suggestion-search-button
    sleep    3
    ${first_result}    Get Text    xpath=//*[@id="__next"]/main/div[2]/div[3]/section/div/div[1]/section[2]/div[2]/ul/li[1]/div[2]
    Should Contain    ${first_result}    The Shawshank Redemption
    sleep    3
    ${results_related} =    Get WebElements    xpath=//*[@id="__next"]/main/div[2]/div[3]/section/div/div[1]/section[2]/div[2]/ul/li[1]/div[2]/div/a
    ${Fresults}    create list
    FOR    ${result}    IN    @{results_related}
        ${result_attr} =    Get Text    ${result}
        Should Contain    ${result_attr}    The Shawshank Redemption
        Append To List    ${Fresults}    ${result_attr}
    END
    sleep    7
    [Teardown]    Close Browser

Scenario_2
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Click Element    xpath=//*[@id="imdbHeader-navDrawerOpen"]
    sleep    2
    Click Element    xpath=//*[@id="imdbHeader"]/div[2]/aside/div/div[2]/div/div[1]/span/div/div/ul/a[2]
    ${TopOne}    Get Text    xpath=//*[@id="main"]/div/span/div/div/div[3]/table/tbody/tr[1]/td[2]/a
    Should Contain    ${TopOne}    The Shawshank Redemption
    sleep    7
    ${imdb-rates} =    Get WebElements    class=titleColumn
    ${Original_ones}    create list
    FOR    ${ratee}    IN    @{imdb-rates}
        ${rateatr}=    get text    ${ratee}
        Append To List    ${Original_ones}    ${rateatr}
    END
    sleep    10
    length should be    ${Original_ones}     250
    sleep    10
    [Teardown]    Close Browser

Scenario_3
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Click Element    xpath=//*[@id="nav-search-form"]/div[1]/div/label
    sleep    1
    Click Element    xpath=//*[@id="navbar-search-category-select-contents"]/ul/a
    sleep    1
    ${Title}    Get Text    xpath=//*[@id="header"]/h1
    Should Contain    ${Title}    Advanced Search
    Click Element    xpath=//*[@id="main"]/div[2]/div[1]/a
    sleep    1
    select checkbox    id=title_type-1
    sleep    1
    Select Checkbox    xpath=//*[@id="title_type-1"]
    sleep    1
    input text    name=release_date-min    2010
    input text    name=release_date-max    2020
    sleep    1
    click button    xpath=//*[@id="main"]/p[3]/button
    sleep    1
    click element    xpath=//*[@id="main"]/div/div[2]/a[3]
    sleep    3
    ${User-Rating} =    Get WebElements    class=ipc-metadata-list-summary-item__t
    ${Original_Rates}    create list
    FOR    ${user-rate}    IN    @{User-Rating}
        ${rate_attr}=    get text    ${user-rate}
        ${rate_attr}=    convert to number    ${rate_attr.strip('$')}
        Append To List    ${Original_Rates}    ${rate_attr}
        ${EMPTY}
    END
    ${sorted_list}=    Sort List    ${Original_Rates}
    ${reverse_sorted_list}=    Reverse List    ${copied_rates}
    Lists Should Be Equal    ${copied_rates}    ${Original_Rates}
    sleep    7
    [Teardown]    Close Browser
