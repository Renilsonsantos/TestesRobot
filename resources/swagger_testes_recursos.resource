*** Settings ***
Documentation
Library  RequestsLibrary
Library  String
Library  Collections



*** Variables ***

${TOKEN}   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTMzMDk5YWZhNzBkNTMwNzVjODFlZjQiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRBVEd0US5ZMVB4a1VxNHJDS00zS2x1djl4TVJIUHU4Mkg4Ylo3ZFNFSVNxTHVQSlIuTEFuNiIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDIwLzEwLzIwMjMsIDIwOjEzOjI5IEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjUzMzA5OWFmYTcwZDUzMDc1YzgxZWY1In1dLCJfX3YiOjAsImlhdCI6MTcxNjE1OTU1NSwiZXhwIjoxNzE2MjQ1OTU1fQ.Lhc9wgBb8tzYQcGL_Kd2KGm6l6DbOVutIVZLhiaK-_c

*** Keywords ***    
Abrir sessão
  ${headers}   Create Dictionary   accept=application/json   Content-Type=application/json    authorization=${TOKEN}
  Create Session   alias=APISwagger   url=https://qualitys-hunters.qacoders-academy.com.br/   headers=${headers}   
   
Entrar com usuario sysadmin
    ${body}    Create Dictionary    mail=sysadmin@qacoders.com    password=1234@Test
    Log    ${body}
   Abrir sessão
    ${resposta}    POST On Session    alias=APISwagger    url=/api/login    json=${body}
    Log    ${resposta.json()}
    Set Test Variable    ${TOKEN}    ${resposta.json()["token"]}
 
    RETURN    ${TOKEN}

Validar o token e gravar no header de autorização
  ${tokenadm}    Entrar com usuario sysadmin    
  ${headers}    Create Dictionary    Authorization=Bearer ${TOKEN}
  ${resposta}    GET On Session    alias=APISwagger    url=/api/validateToken    headers=${headers}
  Log    Resposta da solicitação: ${resposta.content}
  Log    ${TOKEN}
  
Criar um novo login de usuário
  ${palavra_randomica}   Generate Random String   length=8   chars=LETTERS
  ${palavra_randomica}   Convert To Lower Case   ${palavra_randomica} 
  ${palavra_randomica}   Convert To String   ${palavra_randomica}
 
  
  Set Test Variable    ${FULLNAME}            T${palavra_randomica}R
  set Test Variable    ${EMAIL_TEST}          ${palavra_randomica}@qacoders.com.br
  Log                  ${EMAIL_TEST}
  ${numero_randomica}   Generate Random String   length=11   chars=[NUMBERS]
  Set Test Variable    ${CPF}     ${numero_randomica}

Cadastrar novo usuário 
  ${body}  Create Dictionary    fullName=${FULLNAME}   mail=${EMAIL_TEST}    password=1234@Test    accessProfile=ADMIN    cpf=${CPF}    confirmPassword=1234@Test  
  Log    ${body}  

  Abrir sessão 
  ${resposta}      POST On Session      alias=APISwagger    url=/api/user    json=${body}    
  Log    ${resposta.json()}
  Set Suite Variable    ${ID_USUARIO}     ${resposta.json()["user"]["_id"]}
  Set Test Variable     ${RESPOSTA}       ${resposta.json()}
 
Consultar os dados do usuário
  ${resposta_consultar}    GET On Session    alias=APISwagger    url=/api/user/${ID_USUARIO}      expected_status=200
  Set Test Variable    ${RESPOSTA_CONSULTAR}                        ${resposta_consultar.json()}


Conferir se este novo ususário foi cadastrado corretamente
  Log    ${RESPOSTA}
  Dictionary Should Contain Item    ${RESPOSTA}    msg    Olá ${FULLNAME}, cadastro realizado com sucesso.   
  Dictionary Should Contain Key    ${RESPOSTA}   user    _id

    

