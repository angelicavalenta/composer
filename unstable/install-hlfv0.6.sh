(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �[o�0�yxᥐ�P�21�BJ�AI`�S<r�si���>;e����R�i����s|αq{q��0�`k繵w�'t�zzW|�NE��	������v�Wㅎ@L��P�$Qla j1�R�׽��OI!�P�K�ޮ_D�Ȇ�t����Ԧo  �ZC	lv!�.t�s�
#��S>]w�n�ɷ�-�b�"���G/��Ց襑٠�"���h*OodMזCs80�'�7�<��8�����g������Ӑ-�B��hy-�(�j��6���6���߬t�j�9�e��F��냅��dCǵ��)I�h�NfF?�ѓ�q\ja'>�d۹�[q���Ǔ��T䥬�G��b\��ɨO�W���2�����U�����x�^��l�.�ĸ/�C�DS��+�Ql�w�#��l������kߒpedz��\C�-ׅ�4mЈ\Cp��.~�@@�����M<����xҙ���i|��	��k��8H|�����k^��F��y:YlE��\�I���v2������' �v��Ў�q3��raT�

�ٸ/;��!>�� �5��
F6F!��n�! %��<.&���e����4�&��!�\�qC�dYnT�d��
��!��:��6��'_���Rq=��T��q��*�bU�B7�}�Pl�,�"ϗD�O�-,�
�����e��ļ���㡬�_�(��Ox�~��ǧ���`0��`0��`0��`0���'7+]� (  