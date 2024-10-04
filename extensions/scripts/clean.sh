#!/bin/zsh

# Create a temporary directory
temp_dir=$(mktemp -d)

# Read the .gitignore file and create rsync exclude patterns
exclude_patterns=("*/.gitignore")

while IFS= read -r line; do
  if [[ $line == !* ]]; then
    exclude_patterns+=("${line:1}")
  fi
done < extensions/.gitignore

for pattern in "${exclude_patterns[@]}"; do
  echo "HERE" "extensions/$pattern"
  find extensions -path "$pattern" -exec rsync -R {} $temp_dir/ \;
done

rm -rf extensions

mv $temp_dir/extensions extensions
