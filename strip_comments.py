import os
import sys

def strip_comments(text):
    state = 'NORMAL'
    result = []
    i = 0
    n = len(text)
    
    while i < n:
        if state == 'NORMAL':
            if text[i:i+3] == "'''":
                state = "MULTI_SQUOTE"
                result.append(text[i:i+3])
                i += 3
            elif text[i:i+3] == '"""':
                state = "MULTI_DQUOTE"
                result.append(text[i:i+3])
                i += 3
            elif text[i] == "'":
                state = "SQUOTE"
                result.append(text[i])
                i += 1
            elif text[i] == '"':
                state = "DQUOTE"
                result.append(text[i])
                i += 1
            elif text[i:i+2] == '//':
                state = "LINE_COMMENT"
                i += 2
            elif text[i:i+2] == '/*':
                state = "BLOCK_COMMENT"
                i += 2
            else:
                result.append(text[i])
                i += 1
        elif state == 'SQUOTE':
            if text[i] == '\\':
                result.append(text[i:i+2])
                i += 2
            elif text[i] == "'":
                state = "NORMAL"
                result.append(text[i])
                i += 1
            else:
                result.append(text[i])
                i += 1
        elif state == 'DQUOTE':
            if text[i] == '\\':
                result.append(text[i:i+2])
                i += 2
            elif text[i] == '"':
                state = "NORMAL"
                result.append(text[i])
                i += 1
            else:
                result.append(text[i])
                i += 1
        elif state == 'MULTI_SQUOTE':
            if text[i] == '\\':
                result.append(text[i:i+2])
                i += 2
            elif text[i:i+3] == "'''":
                state = "NORMAL"
                result.append(text[i:i+3])
                i += 3
            else:
                result.append(text[i])
                i += 1
        elif state == 'MULTI_DQUOTE':
            if text[i] == '\\':
                result.append(text[i:i+2])
                i += 2
            elif text[i:i+3] == '"""':
                state = "NORMAL"
                result.append(text[i:i+3])
                i += 3
            else:
                result.append(text[i])
                i += 1
        elif state == 'LINE_COMMENT':
            if text[i] == '\n':
                state = "NORMAL"
                result.append(text[i])
                i += 1
            else:
                i += 1
        elif state == 'BLOCK_COMMENT':
            if text[i:i+2] == '*/':
                state = "NORMAL"
                i += 2
            else:
                i += 1
                
    return "".join(result)


def process_directory(directory):
    for root, _, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                filepath = os.path.join(root, f)
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                stripped = strip_comments(content)
                
                with open(filepath, 'w', encoding='utf-8') as file:
                    file.write(stripped)

if __name__ == '__main__':
    process_directory('lib')
