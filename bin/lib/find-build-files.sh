
# === {{CMD}}  all|top|bottom|body|file.name.js  lib/path/to/dom lib/path/to/state etc.
find-build-files () {
  local +x NAME="$1"; shift
  local +x CMD="find $@ -maxdepth 1 -mindepth 1 -type f "

  case "$NAME" in
    all)
      $CMD -type f -iname "*.js" -print
      ;;

    top|bottom)
      $CMD -name "_.${NAME}.js" -print
      ;;

    body)
      $CMD -type f -iname "_.*.js" -prune -o -iname "*.js" -print
      ;;

    *)
      local +x FILES="$($CMD -name "$NAME" -print)"
      if [[ -z "$FILES" ]]; then
        mksh_setup RED "!!! Build files not found: {{$NAME}}"
        exit 1
      fi
      echo "$FILES"
      ;;
  esac

} # === end function
