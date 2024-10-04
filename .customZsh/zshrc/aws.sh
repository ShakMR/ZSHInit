listS3Buckets() {
  if [ -z "$1" ]; then
    echo "Usage: listS3Buckets <exclude>"
    return 1;
  fi

  echo $(aws s3 ls | awk '{print $3}' | grep -v "$1")
}

removeBuckets() {
  # list all buckets and ask for which ones to remove
  echo "Buckets available:"

  # show user the buckets and make them choose which ones to remove
  buckets=($(listS3Buckets "IdontCare"))

  # display buckets with indices
  for i in {1..${#buckets}}; do
    echo "$i. ${buckets[$i]}"
  done

  echo "Enter the numbers of the buckets you want to remove, separated by spaces: "
  read indices

  # convert the string to an array
  indices=(${(s/ /)indices})

  for index in $indices; do
    # convert index to zero-based
    index=$((index))

    if [ -z "${buckets[$index]}" ]; then
      echo "Invalid selection. Exiting..."
      return 1
    fi

    # ask for confirmation
    echo "Are you sure you want to remove bucket: ${buckets[$index]}? (y/n) "
    read confirm
    if [ "$confirm" != "y" ]; then
      echo "Bucket removal cancelled."
      continue
    fi
    echo "Removing item from bucket: ${buckets[$index]}"
    removeVersions ${buckets[$index]}
    aws s3 rm --recursive s3://${buckets[$index]}/
    aws s3 rb s3://${buckets[$index]}
  done
}

removeVersions() {
  # check if s3 bucket has versions and remove them
  if [ -z "$1" ]; then
    echo "Usage: removeVersions <bucket>"
    return 1
  fi

  # check if bucket has versions
  local versions=$(aws s3api list-object-versions  --no-cli-pager --bucket $1 | jq -r '.Versions')
  if [ -z "$versions" ]; then
    echo "No versions found for bucket: $1"
  else
    for version in $(aws s3api list-object-versions  --no-cli-pager --bucket $1 | jq '.Versions[] | {Key: .Key, VersionId: .VersionId}' | jq -r '.Key + ":" + .VersionId'); do
      echo "Removing version: $version"

      aws s3api delete-object --no-cli-pager --bucket $1 --key $(echo $version | cut -d':' -f1) --version-id $(echo $version | cut -d':' -f2)
    done
  fi

# check if bucket has delete markers
  local deleteMarkers=$(aws s3api list-object-versions  --no-cli-pager --bucket $1 | jq -r '.DeleteMarkers')
  if [ -z "$deleteMarkers" ]; then
    echo "No delete markers found for bucket: $1"
  else
    for deleteMarker in $(aws s3api list-object-versions  --no-cli-pager --bucket $1 | jq '.DeleteMarkers[] | {Key: .Key, VersionId: .VersionId}' | jq -r '.Key + ":" + .VersionId'); do
      echo "Removing delete marker: $deleteMarker"

      aws s3api delete-object --no-cli-pager --bucket $1 --key $(echo $deleteMarker | cut -d':' -f1) --version-id $(echo $deleteMarker | cut -d':' -f2)
    done
  fi
}

removeDynamoTable () {
  # list all dynamo tables and ask for which ones to remove in a similar form as with remove buckets
  echo "Tables available:"
  tables=($(aws dynamodb list-tables | jq -r '.TableNames[]'))

  for i in {1..${#tables}}; do
    echo "$i. ${tables[$i]}"
  done

  echo "Enter the numbers of the tables you want to remove, separated by spaces: "

  read indices
  indices=(${(s/ /)indices})

  for index in $indices; do
    index=$((index))

    if [ -z "${tables[$index]}" ]; then
      echo "Invalid selection. Exiting..."
      return 1
    fi

    echo "Are you sure you want to remove table: ${tables[$index]}? (y/n) "
    read confirm
    if [ "$confirm" != "y" ]; then
      echo "Table removal cancelled."
      continue
    fi
    echo "Removing table: ${tables[$index]}"
    aws dynamodb delete-table --no-cli-pager --table-name ${tables[$index]}
  done
}

removeCloudwatchLogGroups () {
  # list all cloudwatch log groups
  echo "Log groups available:"
  logGroups=($(aws logs describe-log-groups | jq -r '.logGroups[].logGroupName'))

  for i in {1..${#logGroups}}; do
    echo "$i. ${logGroups[$i]}"
  done

  # ask the user to enter a string to match against the log group names
  echo "Enter a string to match against the log group names: "
  read matchString

  # filter log groups based on string match
  matchingLogGroups=($(for logGroup in "${logGroups[@]}"; do [[ $logGroup == *"$matchString"* ]] && echo "$logGroup"; done))

  # display the matching log groups to the user for confirmation
  echo "Log groups matching '$matchString':"
  for i in {1..${#matchingLogGroups}}; do
    echo "$i. ${matchingLogGroups[$i]}"
  done

  echo "Are you sure you want to remove these log groups? (y/n) "
  read confirm
  if [ "$confirm" != "y" ]; then
    echo "Log group removal cancelled."
    return 1
  fi

  # remove the matching log groups
  for logGroup in "${matchingLogGroups[@]}"; do
    echo "Removing log group: $logGroup"
    aws logs delete-log-group --no-cli-pager --log-group-name $logGroup
  done
}

removeStacks() {
  #same think for stacks
  echo "Stacks available:"
  stacks=($(aws cloudformation list-stacks --no-cli-pager --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE | jq -r '.StackSummaries[].StackName'))

  for i in {1..${#stacks}}; do
    echo "$i. ${stacks[$i]}"
  done

  echo "Enter the numbers of the stacks you want to remove, separated by spaces: "
  read indices
  indices=(${(s/ /)indices})

  for index in $indices; do
    index=$((index))

    if [ -z "${stacks[$index]}" ]; then
      echo "Invalid selection. Exiting..."
      return 1
    fi

    echo "Are you sure you want to remove stack: ${stacks[$index]}? (y/n) "
    read confirm
    if [ "$confirm" != "y" ]; then
      echo "Stack removal cancelled."
      continue
    fi
    echo "Removing stack: ${stacks[$index]}"
    aws cloudformation delete-stack --no-cli-pager --stack-name ${stacks[$index]}
  done
}
