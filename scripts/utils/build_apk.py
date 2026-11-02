import subprocess

result = subprocess.run(['flutter', 'build', 'apk'], capture_output=True, text=True)

print(result.stdout)      
print(result.stderr)    
print(result.returncode)

if (result.returncode):
    print("sucess")