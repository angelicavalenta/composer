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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q�&)��/�c$��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.���J�e�5�ߖ��2.�?�Uɿ�Y���T��%)���P�wo{�{�l�\�Z��r�K���l��+�r�S�	Xɿ\���:�2�L��Oz�Q�A����P�أ���(I��I�y�;��q��Y��������O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ܫ�s�!������?N���?�-�Ԑ2���WGpbCVk"/�A���&0�Z[�Nu��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��5���M�K�����������w��Ke������]����u�G���G	{��Q��)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Nu�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p_�[��Q��܃���@��w~�N��"r����;i�:�̢n�5�H�X��`a�}� ď�������E�I>�{o-�+����g��x�P����P�ȀS}U���ÛC����F�v#a����+6F�L��~�A�ڀv�,g%�U.܎Pޕ��e��(nugJ7s-j6:p������\��\�"Of�w�f�y4�P?�����scI
&oE�#]��EY�.2&����N�yX12[�FѦI����(�7͕��d(D�$�8�e�G �C'r����"�.a�E��,��~����a�];�Cn9I[RMM/f]}�d	�,�9�x�,z�4����������Wf9�%��M�7��{�%*�/$�G�Om�W�}��J������_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽/S$y�@�� � �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]=t���[���^�湘[��A+\�����{�Х��Soz�.��Ti�\OT�Z�@a����h�i��iʙ������E�r>� ����Mf��rB�=<�!�|-�t��������L^��B>J$��O'��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%���o`���?I�U�G)���������Q���2P����_���=����1���?�d��e������?��W
���*����?�St��(Fxe���	p�d��CД�4�2��:F������8�^��w������ ��(������?|�'��&�<i�'�ˬ�YB�+<�8�0��(�������ll��m3b2n�I���-�/�eK֓�9�6��s�i��nG�sln���_n�ۭ �Q���R��a��^�������*��|��?<���������j����{��������K���Q����T�_)x[�����{3��#�C��)���h��t��>����c����n�]���� ���&s�P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\,Х7(w�j��1<tO��1G�������t���stNnq���*�*�s����g�@[���`%N��;���g�m��I��(/�A���{�?-L{�d҄�NSD�>�1�?��h�������Np���Y�3�ei��@y��1�TpD	i'b$�#�����HȜ'pr�CZ�?�����g��������g��T�_
*����+��ϵެ�]��)�.��+�/�����?F�d��������+��s��w��C�Ƕ �%H�W.���I/�~�a04�|�!��� <g]�܂���o�E�E��Y�fI���(��e����?�����+���L���j�*�7�[c�`��Ǟ#���~����� ���P�;aw괒RCCrG�v��|�a�' �؍r��*mw;p{G��=1@<Z���&#���9���n7���ލ��?N=?�����(MT������^��,����������B�߾�L)\.��"��)x��޾|Y9\./�+������K�A/�?�bhu����?�>?�IW�?e�S�?K#t�������6�26�R��Q��,��x4B��x���o���FQi(C������1�S�����`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���ϻ�������H���J��`��$���������'��՗FU(e���%ȧ��BT��P
^��j�<�{��΁X�qе
�%,�!?��<�}t�gI �����7����*-û���֍��{�.���@7�Gy���D���=�Z�a��=
'���N1��+݅��ΈA??$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�3b��Cb����k�Cba΅�x|�s�[SW�m��Dk�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\�����|t{@�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4�������������[��_~���+��o����Vn�o�2�������'��U��R������6���z��ps'���B�ó�ч���7���3C��o�<���� o=2|rz����k����&>q[��O�A@B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i��z���� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|��)���Ѽ��+���O>��������X����?e��]��te���j����������7��we�����0����rp��/��.��B�*��T�_���.���?�|�����Rp9�a�4��$J1E����>�Q$�8�N�8��(��S��庘�0^e���P��_��~���B���Rp����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^����X�Qg��>Z|�3~��Q!��!��j�����f���Z���2?�N]?�
�j��/��4�C�km�O�t�{a��I��k�1�E\���5re/��}����N�x����&��UM�.�7<�iv��]��w�:��OOL�t�}�ǿh�$���ש�������ֲI�ʭ�����x׵�����[L~��'?ɇ�}��|�����>�9�v��N,���M�jW�i��b����$��׷~���^����Oo�vT�
׾��T4��ng���w��L��fͭ�.����4DU�A�#�Q�����7�������k_�+���
ߎ�}��$w~0������<��0���*�΢г/w�˃����·��śW[���Q��l/����o���:b�]�E��=��e҂H�?m��7����+��z�T��fw���wӻ]��o����������+����O[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k���O4a���"D~��j��Ҿ����}��?��Y<�4�?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n��ŦR��וU��f9�}�axgkxk�p�Y�gK�:{��O�������q�*����vz.���b��m�-�����|8J'N2��8��R��8��ĉ=v�+�B*�b�?��
�� �� ?vQ+��C]!���� ��ēL���tz[�ϕ�8�{>|���y��9�D��B�>���K��t6gLlr�rKn%$l"��Y*��������芬�t.���Jgc�(	�m];f�:y�P������fSd��c3��E�E�V�i�G�h1�	A�d^����P�!&Ly��+����(� ����]��.A�F �5�� �ڱ2�0�R��Z\�k�7,�l�����P�Ǧ*i���G��a��~G��3���':m!_JgZ�{�%�jb��)�W�w�8gބ�c���_3�ܜVe�МF,#!��R�n���a�m��/�+��Sn��/M�������qz����^�M��h����t��n�t���)v8]�ɁSN���%8%������tvb��;�G�_gW�A���MM�G���:�U��(�!<���=j�S���e������_�:��l&m��Dw=aw������w���3�j���$���Ltn�
�f�<(�G%j�!�ͬ��v������p(Z�ׅ�Ӓ���eSE^ə동RPۢ����p�ܴ([�(MQG%���7��=�%�F�����%�����OG���|=]1�-� �����w�y>p��SK�F��Uh{4��$�#1e�c಄�[�q�ˌ	Z��%1�O{Ӻx��n!�����7��Z�b���l���ZU��ۅ��]��v}�`�Յ;p�X�U5 ���>��ټiѽ�Bpx��'o�dc�c��U������������������'��$x��.�\���>������*q��}��z|�z�)ćxlߏ�� �%�����x�o?P�{�@j�Ob�O���'".p��ޑ�o��Е���S�s�v���?�Կ�z��?����3�ҝ�1�w���i ����� �ő���5�&���k��!���p�+O 5�sS��tS���+-��7o0��y`B�#qYH�ya�66���I��9i�\�,��A�<�����ma�7���a�B�' ��p�@�w#�>�M��^�7�-�qj���^!X��{��1'��\��1UuPh��0,��>hFY�Xq"�,6ó��m�`ɊI�H��lC�p%JSE����aT`�������q�e�lx�#\b�U�0O΄Wɂcv{k��H.��\k7S�<tJ�T}�f�8`�d�R��W3����Ҿ�G�i�R�^E�U��1��3zFC�~�a��V�#�!_��0a&�Ä݄	�|�D�ݏ����ѹM=!�ڛz�S�k~~K�)����FȺW�(%��x���c^2��$ӡ\Z��R����L���Hb����sa�P�q��k�=��\�η��bJ��Q�CV���,��fP���A*ҍ�x��S��^��+XBV��E�>�����ë���j2F3�X�'��lDI��8-+�z�����z��
7��T�D�%%��Ho3\��m4_}e�����ـuAY����BDKt��:���(�M�4��V�(��N<Z���>�u��H1J�3�̈́KIF��N ��ڨ���锅��h�&�FK�:`X�pE2�Q2K�rDxAv���u	��x60�)�/&�N�WC� PO/W�h���$f)�h\/�q����Τc� Vhs��TO{��<�EJ���$V)�p���W�����c0r�&q��y �y�ᩱ7-��F��_"�hPˊb�,�"�GI-^V�
�ԸV��ɖp�{�XBi�)����S���n(�Q���z����?�e<�\U�%e9"� �VY��.�q���!+Ut	e�<;(-����?�����ݖ����h�B�R�_��˱|Z�1l�����^�;NY܎���l�϶�϶s�4~�w��FW��]ȵ�;�d��^غc�
���Wi;�L���ʾ}.�6re>����UeE�v��v��滂l���^�����{چ-��B��9(�*a�<���#AԺ��LN�<�&1��ht���U�@�檺��gĎ�3�#MD��Kࢡ*�-��X��5�"����~�ocW�y�eߦ�ȕ�7!`�{��-s�6)�E^iԬ�#oE���؏c�<��l��y��S\W����2�i�/&>�9bV�H?�Sd�AVu�㙁��� ���H�����1�����!�y��6��m���s^
����_
�;q�,<��d;4�5s�>Q
S�b'�������}�A[)����\t0��֢��b�a_l��`�Ȃ�3G�u��Y���i�7k� �yp�{X0�����},C��1����eگ���F�x%�ǹP4V�3R����$�x��a�9т_J��~���U�x:��&�6�J�Y�k,�T92��Z�̀�b���#d,,e�cr�4f�C��5d���P�h"�PB���������{��Ԙ`�F��Z�GЁ�X,��Z2����U�����<�f������pd��^H2������`zá��C�����h^mp\j�A6!����1�8�8���zI� o�N�[��˦?4uL�s�|�s`�g�(�|p.ý�e;á�;�'zX���?1;Ʒ�������xXN$�I�t��G�V%ZKc��i.�$���XR ��78r8X,��h-*7Il!�"��8kPd�*0	��7kβ���ab���`1��m-E�� )G�2
����C�;��E���3r1^�0��U�O����x}=RU���h4��l%�`LB��K�����p�`�a,�*���(���!�|�-v����+`qO���b����K;� C���Ƥ S��J�F�E5\��c4ϥ0f��Q"lmO-���qCN�)$Z� |��E�ڬb�^?Mz�
-�����c�q��ǩ��b�o#��{j�l!����Br��vn���]���qސ)��{B��[�­��tߜ��4�I�j�h�{�>p�����������[���l�K�8���; �Q�<�G5���E�r����6�����{��=�~���g_��s�����������s?����ך��Ŵr��9�q"��]�#p���%���_��o=��_���o�������L>��g��>������\���{|)	��A��֝&�o���^��d:Q��� W��Н�{��m���v��8�/������o����A~=G���yy���K���P;j�Cph�����z�������C�t���������@�<5��6�Ao��T�	4�Rf�a���ۢ��m!t�����o=gb謏��<B���u�9j���3p�:�g�|Ju>�:<�8�x�xg�H��5p;������4�u��3gƉ�:sf�iδ gΌc�q܆93g��{�)0�cf΍�Ý"��)m��%��#����vm�;&���$'9�I���W�=M\  