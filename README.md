# Project: mindie gateway for api-key validation

MindIE natively do not support API_KEY validation
this gateway add key validation on top of mindie service
you should put your api key into this file: api_keys.txt 



# Setup instruction
Create api_key.txt file
```
echo e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8 >> api_key.txt
```

Validate file content
api_key.txt output checking
```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ cat api_keys.txt
```

expected output
```
e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8
```

Setup dockerfile
```
 docker-compose up --build -d
 docker-compose logs -f mindie-gateway
```


# Usage Instruction

## Valid APK Key, Sample Request follow openai v1/chat/completions api syntax
```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8" \
-d '{"model": "gpt-4o", "messages": [{"role": "user", "content": "Hello"}]}'
```

mindie service response:
```
{"id": "chatcmpl-123","object": "chat.completion","created": 1677652288,"model": "gpt-4o-mock","choices":[{"index":0,"message":{"role":"assistant","content":"Hello! This is a mock response from the vLLM API gateway. Your API key was validated successfully."},"finish_reason":"stop"}],"usage":{"prompt_tokens":10,"completion_tokens":20,"total_tokens":30}}
```

## Non Valid APK Key, Sample Request follow openai v1/chat/completions api syntax
```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer xxxxxxxx.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8a"   \
-d '{"model": "gpt-4o", "messages": [{"role": "user", "centent": "Hello"}]}'
```
mindie gateway service response:
```
{"error":{"message":"Unauthorized: Invalid API key","type":"invalid_request_error","code":"invalid_api_key"}}
```


## Testing for debug
Sample Request again mock response with -H "X-Mock-Response: true"  header
```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8a" \
-H "X-Mock-Response: true"   \
-d '{"model": "gpt-4o", "messages": [{"role": "user", "content": "Hello"}]}'
```

mock response:
```
{"error":{"message":"Unauthorized: Invalid API key","type":"invalid_request_error","code":"invalid_api_key"}}demo@DESKTOP-OSLI7Q7:~/mindie-gateway$
```
