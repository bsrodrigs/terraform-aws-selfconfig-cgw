# This file holds shared secrets or RSA private keys for authentication.\n# RSA private key for this host, authenticating it to any other host\n# which knows the public part.

# Tunnel 1
GREEN_OUTSIDE_IP1 BLUE_OUTSIDE_IP1 : PSK "TUNNEL1_PRESHARED_KEY"

# Tunnel 2
GREEN_OUTSIDE_IP1 BLUE_OUTSIDE_IP2 : PSK "TUNNEL2_PRESHARED_KEY"