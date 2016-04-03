
# === {{CMD}}  ...
build-nodejs () {

  local +x OUTPUT="build/node.js"
  rm -f "$OUTPUT"
  rm -f "$OUTPUT".map

  temp="$TEMP/spec"

  # === NODE: =================================================================
  echo -e "=== Building: ${Bold}$OUTPUT${Color_Off}"
  local names="spec base state node"
  cat $($0 top-build-files $names) $($0 body-build-files $names) $($0 bottom-build-files $names) > "$OUTPUT"
  err_found=""

  while IFS= read LINE; do
    if [[ "$LINE" == *"   at "* ]]; then
      new_line="$(echo $LINE | tr -s ' ')"
      func_name="$(echo $new_line | cut -d' ' -f 2)"
      file="$(echo $new_line | cut -d' ' -f 3 | cut -d'(' -f2 | cut -d':' -f1)"
      num="$(echo $new_line | cut -d' ' -f 3 | cut -d'(' -f2 | cut -d':' -f2)"
      line="$([[ -f "$file" ]] && sed -n -e ${num}p "$file" || :)"
      if [[ -n "$line" ]]; then

        while IFS= read RESULT; do
          echo -e -n "  ${Green}$func_name${Color_Off} -> "
          echo -e "${BGreen}$(echo $RESULT | cut -d':' -f1)${Color_Off} ${BRed}@${Color_Off} ${Bold}$(echo $RESULT | cut -d':' -f2)${Color_Off}"
          echo -e -n "    ${BOrange}"
          echo -e $(echo $RESULT | cut -d':' --complement  -f1-3)${Color_Off}
          echo "-----------------------------------------------------------------"
        done < <(ag --vimgrep --literal "$line" lib)

      else
        echo $LINE
      fi
      err_found="yes"
    else
      echo "$LINE"
    fi
  done < <(node lib/node.spec.js test 2>&1) # || { stat=$?; echo -e "=== ${Red}Failed${Color_Off}" 1>&2; exit $stat; })

  [[ -n "$err_found" ]] && exit 1 || :
  # echo -e "=== Creating .map file..."
  # ugly "node" $names
  # node "lib/node.spec.js" test &>$temp || { stat=$?; cat "$temp"; echo -e "=== ${Red}Failed${Color_Off}" 1>&2; exit $stat; }
  echo -e "=== Done building: ${Green}$OUTPUT${Color_Off}"

} # === end function