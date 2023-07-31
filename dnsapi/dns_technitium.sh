#!/usr/bin/env sh
#
#Author: Chenhao Shen <shenchenhao1234@hotmail.com>
#
# Env #
#TECHNITIUM_API=""
#TECHNITIUM_API_TOKEN=""

########  Public functions ########

#Usage: dns_technitium_add   _acme-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
dns_technitium_add() {
  fulldomain=$1
  txtvalue=$2

  _info "Using technitium"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"

  TECHNITIUM_API_TOKEN="${TECHNITIUM_API_TOKEN:-$(_readaccountconf_mutable TECHNITIUM_API_TOKEN)}"
  TECHNITIUM_API="${TECHNITIUM_API:-$(_readaccountconf_mutable TECHNITIUM_API)}"

  if [ -z "$TECHNITIUM_API" ] || [ -z "$TECHNITIUM_API_TOKEN" ]; then
    TECHNITIUM_API=""
    TECHNITIUM_API_TOKEN=""
    _err "You don't specify technitium api endpoint and token yet."
    return 1
  fi

  # save the api endpoint and api token to the account conf file.
  _saveaccountconf_mutable TECHNITIUM_API "$TECHNITIUM_API"
  _saveaccountconf_mutable TECHNITIUM_API_TOKEN "$TECHNITIUM_API_TOKEN"

  curl -L "http://$TECHNITIUM_API/api/zones/records/add?token=$TECHNITIUM_API_TOKEN&domain=$fulldomain&type=TXT&ttl=60&text=$txtvalue"

  # Wait to take effect
  sleep 10
  return 0
}

#Usage: fulldomain txtvalue
#Remove the txt record after validation.
dns_technitium_rm() {
  fulldomain=$1
  txtvalue=$2

  _info "Using technitium"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"

  TECHNITIUM_API_TOKEN="${TECHNITIUM_API_TOKEN:-$(_readaccountconf_mutable TECHNITIUM_API_TOKEN)}"
  TECHNITIUM_API="${TECHNITIUM_API:-$(_readaccountconf_mutable TECHNITIUM_API)}"

  if [ -z "$TECHNITIUM_API" ] || [ -z "$TECHNITIUM_API_TOKEN" ]; then
    TECHNITIUM_API=""
    TECHNITIUM_API_TOKEN=""
    _err "You don't specify technitium api endpoint and token yet."
    return 1
  fi

  # save the api endpoint and api token to the account conf file.
  _saveaccountconf_mutable TECHNITIUM_API "$TECHNITIUM_API"
  _saveaccountconf_mutable TECHNITIUM_API_TOKEN "$TECHNITIUM_API_TOKEN"

  curl -L "http://$TECHNITIUM_API/api/zones/records/delete?token=$TECHNITIUM_API_TOKEN&domain=$fulldomain&type=TXT&text=$txtvalue"

  # Wait to take effect
  return 0

}

####################  Private functions below ##################################
