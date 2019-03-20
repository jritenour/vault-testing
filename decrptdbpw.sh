#Encrypt & store passwords in vault
#Jason Ritenour
#3/19/2019
#This is a simple script to decyrpt passwords and store the ciphertext in HashiCorp Vault. It takes one arguments - the user ($1).

# Pass the username to get the cipher text from the kv store	
CIPHER=$(curl --header "X-Vault-Token: $VAULT_TOKEN" --request GET  $VAULT_ADDR/v1/secret/db-$1 |jq -r ".data.$1")

#echo $CIPHER

#Take the ciphertext and decrypt it to base64
BASEPW=$(curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data '{"ciphertext": "'$CIPHER'"}' $VAULT_ADDR/v1/transit/decrypt/$1 | jq -r '.data.plaintext')
#echo $BASEPW

#Take the base64 text and decode it to plaintext
PASS=$(base64 --decode <<< "$BASEPW")
echo $PASS
