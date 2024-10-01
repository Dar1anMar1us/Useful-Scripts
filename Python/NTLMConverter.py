import hashlib

def ntlmv1_hash(password):
    # Convert password to UTF-16LE
    utf16_password = password.encode('utf-16le')
    # Calculate MD4 hash
    hash_obj = hashlib.new('md4', utf16_password)
    return hash_obj.hexdigest()

# Example usage
password = "mypassword"
hash_result = ntlmv1_hash(password)
print(hash_result)
