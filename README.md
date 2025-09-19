# Project: mindie gateway for api-key validation

MindIE natively do not support API_KEY validation
this gateway add key validation on top of mindie service
you should put your api key into this file: api_keys.txt 

This is working on HTTP protocl.

# Setup instruction
Go to conf directory
```
cd ./conf
```

Create api_key.txt file
```
echo e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8 >> api_key.txt
```

Validate file content
api_key.txt output checking
```
cat api_keys.txt
```

expected output
```
e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8
```

Setup dockerfile
```
 docker-compose up --build -d mindie-gateway
 docker-compose logs -f mindie-gateway
```


# Usage Instruction

## Valid APK Key, Sample Request follow openai v1/chat/completions api syntax
```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8" \
-d '{"model": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B", "messages": [{"role": "user", "content": "Hello"}]}'
```

mindie service response:
```
{"id":"chatcmpl-63fad601fc4a43bab8ac355b2fbaec04","object":"chat.completion","created":1758267015,"model":"deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B","choices":[{"index":0,"message":{"role":"assistant","reasoning_content":"Alright, the user sent \"Hello.\" That's a friendly greeting. I should respond in a warm and welcoming manner.\n\nI want to make sure they feel comfortable, so I'll offer help with whatever they need.\n\nKeeping it open-ended so they feel free to ask anything is important.\n\nAlso, I should keep my response concise and approachable.\n","content":"\n\nHello! How can I assist you today?","tool_calls":[]},"logprobs":null,"finish_reason":"stop","stop_reason":null}],"usage":{"prompt_tokens":6,"total_tokens":87,"completion_tokens":81,"prompt_tokens_details":null},"prompt_logprobs":null,"kv_transfer_params":null}
```

## Non Valid APK Key, Sample Request follow openai v1/chat/completions api syntax
```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer xxxxxxxx.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8a"   \
-d '{"model": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B", "messages": [{"role": "user", "centent": "Hello"}]}'
```
mindie gateway service response:
```
{"error":{"message":"Unauthorized: Invalid API key","type":"invalid_request_error","code":"invalid_api_key"}}
```


# Testing for debug

## Valid Key on Mock service

Add -H "X-Mock-Response: true"  header in curl request. 

```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer e3fd528f06.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8a" \
-H "X-Mock-Response: true"   \
-d '{"model": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B", "messages": [{"role": "user", "content": "Hello"}]}'
```

mock response:
```
{"id": "chatcmpl-123","object": "chat.completion","created": 1677652288,"model": "gpt-4o-mock","choices":[{"index":0,"message":{"role":"assistant","content":"Hello! This is a mock response from the vLLM API gateway. Your API key was validated successfully."},"finish_reason":"stop"}],"usage":{"prompt_tokens":10,"completion_tokens":20,"total_tokens":30}}
```


## Non Valid Key on Mock service

Add -H "X-Mock-Response: true"  header in curl request. 

```
demo@DESKTOP-OSLI7Q7:~/mindie-gateway$ 
curl -X POST http://localhost/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer xxxxxxxx.dYiKQBr0uz3sHAAb295ec84dc797b6440f82d8a"   \
-H "X-Mock-Response: true"   \
-d '{"model": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B", "messages": [{"role": "user", "centent": "Hello"}]}'
```

mock response:
```
{"error":{"message":"Unauthorized: Invalid API key","type":"invalid_request_error","code":"invalid_api_key"}}demo@DESKTOP-OSLI7Q7:~/mindie-gateway$
```