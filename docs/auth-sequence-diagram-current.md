use in websequencediagrams.com to update image

title Passwordless Authentication

Server->MDNS Network: Broadcast _phobrary identity
Client->MDNS Network: Scan for announced _phobrary servers
MDNS Network->Client: Respond with DNS names or IP's for servers
Client->Server: Race status page lookups for all found addresses
Client->User: Display Server
User->Client: Choose to connect to named server on fastest address
Client->User: Tell to run auth-creation-script on server
User->Server: Create AuthenticationAttempt(valid 10 minutes)
Server->User: Display OneTimeCode associated with server secret
User->Client: Enter 6-char OneTimeCode
Client->Server: Creates session with TOTP based on OneTimeCode
Server->Client: Responds with sessiontoken and session ROTP:32 secret
Client->Server: Session token and TOTP based on secret in custom headers based on secret for subsequent communications
