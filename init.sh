echo "Installing curl"
sudo apt-get -y install curl > /dev/null

echo "Add the key for the 1Password apt repository"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo gpg --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "Add the 1Password apt repository"
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list > /dev/null

echo "Add the debsig-verify policy"

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ > /dev/null
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol > /dev/null
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

echo "Install 1password"1
sudo apt-get update > /dev/null
sudo apt-get install -y jq 1password 1password-cli > /dev/null

read -p '
To continue setup, you need to sign in to 1Password.
After signing in, go to Settings > Developer and select "Integrate with 1Password CLI"
Also click "Set Up SSH Agent..." and follow the prompts.
Then come back to this terminal and continue.
Press Enter to open 1password
' </dev/tty

tmp=$(1password &> /dev/null) &

read -p '
Press Enter when you have logged in and enabled CLI integration and set up SSH agent.
' </dev/tty

echo "Add github.com as known host"
ssh-keygen -R github.com  > /dev/null
curl -L https://api.github.com/meta | jq -r '.ssh_keys | .[]' | sed -e 's/^/github.com /' >> ~/.ssh/known_hosts

echo "Clone ubuntu repo"
git clone git@github.com:Hans-Kristian-UFST/ubuntu.git

cd ubuntu
./setup.sh
