*** Settings ***
Resource  ../resources/swagger_testes_recursos.resource
Resource  ../resources/diretoria_swagger_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com POST: Cadastrar um novo ususário com sucesso  
    Abrir sessão
    Entrar com usuario sysadmin
    Validar o token e gravar no header de autorização
    Criar um novo login de usuário
    Cadastrar novo usuário
    Consultar os dados do usuário
    Conferir se este novo ususário foi cadastrado corretamente

Cenário com POST: Cadastrar diretoria
   Criar sessão
   Abrir com usuario sysadmin
   Salvar o token e gravar no header de autorização
   Massa de dados diretoria 
   incluir nova diretoria  
   validar campo obrigatório vazio a mensagem O campo boardName é obrigatório
   validar campo preenchido com caracteres não permitidos "O campo boardName só pode conter (descrição_caracteres)
   deve permitir somente letras maiúsculas, minúsculas e o caractere especial & 
    