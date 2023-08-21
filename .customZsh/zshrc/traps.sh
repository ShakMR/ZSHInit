function command_not_found_handler() {
  command=$1
  args=${@:2}
  echo $args
  if [ "$command" = "--" ] && [ "$args" = "" ]
  then
    getProjects;
  else
    echo "Command $command not found. (args: $args)";
    return 127
  fi
}
