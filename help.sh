dir_code=$dir_log/code

default_env_name=(
  JD_COOKIE
  FRUITSHARECODES
  PETSHARECODES
  PLANT_BEAN_SHARECODES
  DREAM_FACTORY_SHARE_CODES
  DDFACTORY_SHARECODES
  JDZZ_SHARECODES
  JDJOY_SHARECODES
  JXNC_SHARECODES
  BOOKSHOP_SHARECODES
  JD_CASH_SHARECODES
  JDSGMH_SHARECODES
  JDCFD_SHARECODES
  JDHEALTH_SHARECODES
)
default_var_name=(
  Cookie
  ForOtherFruit
  ForOtherPet
  ForOtherBean
  ForOtherDreamFactory
  ForOtherJdFactory
  ForOtherJdzz
  ForOtherJoy
  ForOtherJxnc
  ForOtherBookShop
  ForOtherCash
  ForOtherSgmh
  ForOtherCfd
  ForOtherHealth
)
import_help_config () {
    [ ! -n "$env_name" ] && env_name=($(echo ${default_env_name[*]}))
    [ ! -n "$var_name" ] && var_name=($(echo ${default_var_name[*]}))
}

## 统计用户数量
count_user_sum () {
    for ((i=1; i<=${SUM:-$((3 * 4))}; i++)); do
        local tmp1=Cookie$i
        local tmp2=${!tmp1}
        [[ $tmp2 ]] && user_sum=$i || break
    done
}

combine_sub() {
    local what_combine=$1
    local combined_all=""
    local tmp1 tmp2
    local block_cookie=${TempBlockCookie:-""}
    for ((i = 1; i <= $user_sum; i++)); do
        for num in $block_cookie; do
            [[ $i -eq $num ]] && continue 2
        done
        local tmp1=$what_combine$i
        local tmp2=${!tmp1}
        combined_all="$combined_all&$tmp2"
    done
    echo $combined_all | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||}"
}

## 正常依次运行时，组合所有账号的Cookie与互助码
combine_all() {       
    echo "组合所有账号的Cookie与互助码,共"${#env_name[*]}"个"
    for ((i = 0; i < ${#env_name[*]}; i++)); do
        result=$(combine_sub ${var_name[i]})
        if [[ $result ]]; then
            export ${env_name[i]}="$result"
        fi
    done
}

if [[ $p1 == *.js ]]; then
     if [[ $AutoHelpOther == true ]] && [[ $(ls $dir_code) ]]; then
        echo "导入code生成的互助码"
        local latest_log=$(ls -r $dir_code | head -1)
        . $dir_code/$latest_log
    fi       
fi
import_help_config
count_user_sum
combine_all