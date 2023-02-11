echo "Applying ~/.bashrc..."

#######################################
# Create Alias for input command
# Arguments:
#   Alias Name
#   Command
#   Arguments for Command
#######################################
# TODO: 각 case별 인자 개수 check
als() {
  # $alias_=$cmd_line
  # $alias_="$cmd $arg1 $arg2.."

  declare -a aliases
  declare -a cmd_lines

  alias_=$1
  cmd=$2

  case $cmd in
    brew)
      brew_services="brew services"
      svc=$3

      # arg 
      args=("run" "start" "stop" "restart" "info")

      for arg in $args; do
        aliases+="${alias_}${arg}"
        cmd_lines+="$brew_services $arg $svc"
      done

      # client
      dbms=$3
      case $dbms in
        mysql)
          aliases+="${alias_}client"
          cmd_lines+="mysql -uroot"
          ;;
        postgresql@14)
          aliases+="${alias_}client"
          cmd_lines+="psql postgres"
          ;;
        *)
          ;;
      esac
      ;;

    ssh)
      aliases+=$alias_
      cmd_lines+="$cmd $3@$4"
      ;;

    ms)
      aliases+=$alias_
      cmd_lines+="$grep -rnw . -e $3"
      ;;

    mf)
      aliases+=$alias_
      cmd_lines+="$grep -rnw . -e $3"
      ;;

    *)
      aliases+=$alias_
      cmd_lines+="${@:2}"
      ;;

  esac

  for (( i=0; i<${#aliases[@]}; i++ )); do
    alias_=${aliases[$i]}
    cmd_line=${cmd_lines[$i]}

    alias $alias_="echo ${cmd_line} && ${cmd_line}"
  done
}

echo "Applying dot files in ~/bashrc..."

#######################################
# Import Secondary Bash Files
#######################################
for file in ~/bashrc/*; do
  if test -f $file; then
    echo "ㄴ$file"
    source $file
  fi
done

