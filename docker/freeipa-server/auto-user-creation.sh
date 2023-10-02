echo "ing FreeIPA CLI Interface to do basic operations"

export USER_DEFAULT_PWD="homelab@123"
export ROOT_PWD="freeipa@123"
export DOMAIN="homelab.com"

sudo echo -e "${ROOT_PWD}\n" | (sudo kinit admin)

sudo echo -e "${USER_DEFAULT_PWD}\n" | ipa user-add usera --first=User --last=A --password


ipa group-add-member admins --users=usera

ipa group-add-member sysadmins --users=usera

ipa sudorule-add All \
    --hostcat=all \
    --cmdcat=all \
    --runasusercat=all \
    --runasgroupcat=all

echo "Just add the users or groups to this sudo rule that you want to be able to sudo with any command"
ipa sudorule-add-user --groups=admins All

ipa sudorule-add-option All \
    --sudooption='!authenticate'

echo "list rule All"
ipa sudorule-find All