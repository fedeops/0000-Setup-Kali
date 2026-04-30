#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

show_summary() {
  echo ""
  echo "========================================"
  echo " SETUP SUMMARY"
  echo "========================================"

  COUNT_OK=0
  COUNT_SKIP=0
  COUNT_FAIL=0

  for i in "${!SUMMARY_LABELS[@]}"; do
    case "${SUMMARY_STATUS[$i]}" in
      OK)
        echo -e " ${GREEN}[✓ SUCCESSFUL]${NC} ${SUMMARY_LABELS[$i]}"
        ((COUNT_OK++))
        ;;
      SKIP)
        echo -e " ${BLUE}[● ALREADY PRESENT]${NC} ${SUMMARY_LABELS[$i]}"
        ((COUNT_SKIP++))
        ;;
      FAIL)
        echo -e " ${RED}[✗ FAILED]${NC} ${SUMMARY_LABELS[$i]}"
        ((COUNT_FAIL++))
        ;;
    esac
  done

  echo ""
  echo "----------------------------------------"
  echo -e " ${GREEN}Successful:${NC}      $COUNT_OK"
  echo -e " ${BLUE}Already present:${NC} $COUNT_SKIP"
  echo -e " ${RED}Failed:${NC}          $COUNT_FAIL"
  echo "========================================"

  export COUNT_OK COUNT_SKIP COUNT_FAIL
}
