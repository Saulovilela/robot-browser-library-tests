*** Settings ***
Library  Browser
Library  FakerLibrary

*** Variables ***
${BROWSER}           chromium
${HEADLESS}          ${false}
${SITE_SERVE_REST}   https://front.serverest.dev/

*** Keywords ***
Abrir o navegador
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    
    New Context    viewport={'width': 1200, 'height': 800}

Ir para o site Serve Rest Front
    New Page       url=${SITE_SERVE_REST}
    ${title}       Get Title  ==  Front - ServeRest
    Log  ${title}

Preencher os dados do novo usuário e cadastrar
    # Record Selector
    # Click    css=.btn-link
    # Click    text="Cadastre-se"
    Click       css=a[data-testid='cadastrar']
    ${EMAIL}    FakerLibrary.Email
    Set Test Variable    ${EMAIL}
    Fill Text   css=input[data-testid='nome']       Saulo Vilela
    Fill Text   css=input[data-testid='email']      ${EMAIL}
    Fill Text   css=input[data-testid='password']   123456
    Check Checkbox  css=input[data-testid='checkbox']
    # Click    css=button[data-testid='cadastrar']
    Click   xpath=//*[@id="root"]//button >> text="Cadastrar"

Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1   visible
    Get Text    h1  ==  Bem Vindo Saulo Vilela
    Get Element States    css=button[data-testid='logout']  validate  value & visible

Cadastrar novo usuário
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Acessar a Lista de usuários
    Click        css=a[data-testid='listarUsuarios']

Conferir que o usuário aparece na listagem
    ${elemento}      Get Table Cell Element    css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}  Get Text  ${elemento}  ==  Saulo Vilela
    Highlight Elements    ${elemento}
    Take Screenshot       fullPage=${true}  