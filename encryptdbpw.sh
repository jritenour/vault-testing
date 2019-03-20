#Encrypt & store passwords in vault
#Jason Ritenour
#3/19/2019
#This is a simple script to encyrpt passwords and store the ciphertext in HashiCorp Vault. It takes two arguments - the user ($1) and password ($2)  

# Take the password at convert to base4
BASEPW=$(base64 <<< "$2")

#echo $BASEPW
# Pass the base64-encoded plaintext in the request payload, and associate it with the username
CIPHER=$(curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data '{"plaintext": "'$BASEPW'"}' $VAULT_ADDR/v1/transit/encrypt/$1 | jq '.data.ciphertext')

#echo $CIPHER

#Create payload.json from username & ciphertext output
tee payload.json << EOF
{
  "$1": $CIPHER
}
EOF

# Post the payload.json to the secrets endpoint
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json  $VAULT_ADDR/v1/secret/db-$1

# Remove the payload.json file
rm payload.json -f
