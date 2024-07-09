import os
import sys

aws_config_path = "~/.aws/config"

def read_aws_config(env_name):
    env_vars = {}
    with open(aws_config_path, "r") as f:
        current_env = None
        for line in f:
            line = line.strip()
            if line.startswith("[") and line.endswith("]"):
                current_env = line[1:-1]
            elif current_env == env_name and "=" in line:
                key, value = line.split("=")
                env_vars[key.strip()] = value.strip()
    return env_vars

def main():
    if len(sys.argv) != 2:
        print("Usage: {} <env>".format(sys.argv[0]))
        sys.exit(1)

    env_name = sys.argv[1]
    env_vars = read_aws_config(env_name)

    for key, value in env_vars.items():
        os.environ[key.upper()] = value
        print('export {}="{}"'.format(key.upper(), value))

if __name__ == "__main__":
    main()

    

