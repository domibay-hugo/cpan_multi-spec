use strict;
use warnings;

####### HOWTO ADD A NEW CONSTANT:
#
# 1/ add new constant name (incl. SSL_ prefix) in __DATA__ part
#    of this file (helper_script/regen_openssl_constants.pl)
#
# 3/ take the output of the following command:
#    perl helper_script/regen_openssl_constants.pl -gen-pod
#    and paste it manually into:
#    a/ SSLeay.pm (@EXPORT_OK - the first 3-columns part)
#    b/ SSLeay.pod (constants section)
#
# 3/ run: perl Makefile.PL && make && make test

# some hints if you want to play more with this script:
#
# you can run this script manually from the Net::SSLeay dist dir like this:
#      perl helper_script/regen_openssl_constants.pl -gen-c > constants.c
#
# or you can generate test file like this:
#      perl helper_script/regen_openssl_constants.pl -gen-t > t/local/20_autoload.t
#
# or you can generate pod doc section with all available constants:
#      perl helper_script/regen_openssl_constants.pl -gen-pod > 3columns-const-list.txt

package MySubClass;
use base 'ExtUtils::Constant::Base';

sub assignment_clause_for_type {
  my ($self, $args, $value) = @_;
  my ($name, $valuex) = @{$args}{qw(name value)};
  return "goto not_there;" if $value && $value eq '_TEST_INVALID_CONSTANT';
  return <<"MARKER"

#ifdef $value
        return $value;
#else
        goto not_there;
#endif
MARKER
}

sub C_constant_return_type { "static double" }

sub return_statement_for_notfound {
  return <<"MARKER"

  errno = EINVAL;
  return 0;

not_there:
  errno = ENOENT;
  return 0;
MARKER
}

package main;

sub const_list_3columns {
  my ($list, $include_test_constant) = @_;
  my @c = sort map { $_->{name} } @$list;
  @c = grep { $_ !~ /^_TEST_INVALID_CONSTANT$/ } @c unless $include_test_constant;
  my $rows = int((scalar(@c)+2)/3); #3 columns
  my $max_width_left = 0;
  for my $i (0..$rows-1) {
    my $l = length($c[$i]);
    $max_width_left = $l if $max_width_left < $l;
  }
  my $max_width_middle = 0;
  for my $i ($rows..2*$rows-1) {
    my $l = length($c[$i]);
    $max_width_middle = $l if $max_width_middle < $l;
  }
  my $rv = '';
  for my $i (0..$rows-1) {
    my $left = $c[$i];
    my $middle = $c[$rows + $i] || '';
    my $right = $c[2*$rows + $i] || '';
    $rv .= " $left" . " " x ($max_width_left-length($left));
    $rv .= " $middle" . " " x ($max_width_middle-length($middle));
	$rv .= " $right\n";
  }
  return $rv;
}

sub t_file {
  my ($count, $list) = @_;
  return <<MARKER;
# *** Automatically generated by helper_script/regen_openssl_constants.pl
# *** Do not edit manually!

use lib 'inc';

use Net::SSLeay;
use Test::Net::SSLeay;

eval "use Test::Exception;";
if (\$@) {
    plan skip_all => 'Some tests need Test::Exception';
} else {
    plan tests => $count;
}

my \@c = (qw/
$list
/);

my \@missing;
my \%h = map { \$_=>1 } \@Net::SSLeay::EXPORT_OK;

for (\@c) {
  like(eval("&Net::SSLeay::\$_; 'ok'") || \$\@, qr/^(ok|Your vendor has not defined SSLeay macro.*)\$/, "\$_");
  push(\@missing, \$_) unless \$h{\$_};
}

is(join(",", sort \@missing), '', 'constants missing in \@EXPORT_OK count='.scalar(\@missing));

MARKER
}

sub print_output {
  my ($src, $filename) = @_;
  if ($filename) {
    open F, ">", $filename or die "cannot open $ARGV[1] for writting";
	binmode F; #to make sure that also on MS Windows we will have UNIX line ending
	print F $src;
	close F;
  }
  else {
    print STDOUT $src;
  }
}

my @constants;

while (<DATA>) {
  s/^\s+|\s+$//g;  # skip leading+trailing spaces
  s/#.*$//;        # skip comments
  next if /^\s*$/; # skip empty lines
  my $v = $_;
  (my $n = $v) =~ s/^SSL_//;
  push @constants, { name=>$n, value=>$v };
}

if ($ARGV[0] && $ARGV[0] eq '-gen-c') {
  my $src = "/* DO NOT EDIT THIS FILE - update __DATA__ section of helper_script/regen_openssl_constants.pl */\n\n";
  $src .= MySubClass->C_constant({breakout=>~0,indent=>20}, @constants);
  print_output($src, $ARGV[1]);
  warn "\n### do not forget to update (manually) SSLeay.pod(constants list) + SSLeay.pm(\@EXPORT_OK)\n\n";
}
elsif ($ARGV[0] && $ARGV[0] eq '-gen-t') {
  my $src = t_file(scalar(@constants), const_list_3columns(\@constants));
  print_output($src, $ARGV[1]);
}
elsif ($ARGV[0] && $ARGV[0] eq '-gen-pod') {
  my $src = const_list_3columns(\@constants);
  print_output($src, $ARGV[1]);
}
else {
  die "invalid param - usage:\n  $0 -gen-c\n  $0 -gen-pod\n  $0 -gen-t\n";
}

__DATA__
_TEST_INVALID_CONSTANT
ASN1_STRFLGS_ESC_CTRL
ASN1_STRFLGS_ESC_MSB
ASN1_STRFLGS_ESC_QUOTE
ASN1_STRFLGS_RFC2253
EVP_PKS_DSA
EVP_PKS_EC
EVP_PKS_RSA
EVP_PKT_ENC
EVP_PKT_EXCH
EVP_PKT_EXP
EVP_PKT_SIGN
EVP_PK_DH
EVP_PK_DSA
EVP_PK_EC
EVP_PK_RSA
GEN_DIRNAME
GEN_DNS
GEN_EDIPARTY
GEN_EMAIL
GEN_IPADD
GEN_OTHERNAME
GEN_RID
GEN_URI
GEN_X400
LIBRESSL_VERSION_NUMBER
MBSTRING_ASC
MBSTRING_BMP
MBSTRING_FLAG
MBSTRING_UNIV
MBSTRING_UTF8
NID_OCSP_sign
NID_SMIMECapabilities
NID_X500
NID_X509
NID_ad_OCSP
NID_ad_ca_issuers
NID_algorithm
NID_authority_key_identifier
NID_basic_constraints
NID_bf_cbc
NID_bf_cfb64
NID_bf_ecb
NID_bf_ofb64
NID_cast5_cbc
NID_cast5_cfb64
NID_cast5_ecb
NID_cast5_ofb64
NID_certBag
NID_certificate_policies
NID_client_auth
NID_code_sign
NID_commonName
NID_countryName
NID_crlBag
NID_crl_distribution_points
NID_crl_number
NID_crl_reason
NID_delta_crl
NID_des_cbc
NID_des_cfb64
NID_des_ecb
NID_des_ede
NID_des_ede3
NID_des_ede3_cbc
NID_des_ede3_cfb64
NID_des_ede3_ofb64
NID_des_ede_cbc
NID_des_ede_cfb64
NID_des_ede_ofb64
NID_des_ofb64
NID_description
NID_desx_cbc
NID_dhKeyAgreement
NID_dnQualifier
NID_dsa
NID_dsaWithSHA
NID_dsaWithSHA1
NID_dsaWithSHA1_2
NID_dsa_2
NID_email_protect
NID_ext_key_usage
NID_ext_req
NID_friendlyName
NID_givenName
NID_hmacWithSHA1
NID_id_ad
NID_id_ce
NID_id_kp
NID_id_pbkdf2
NID_id_pe
NID_id_pkix
NID_id_qt_cps
NID_id_qt_unotice
NID_idea_cbc
NID_idea_cfb64
NID_idea_ecb
NID_idea_ofb64
NID_info_access
NID_initials
NID_invalidity_date
NID_issuer_alt_name
NID_keyBag
NID_key_usage
NID_localKeyID
NID_localityName
NID_md2
NID_md2WithRSAEncryption
NID_md5
NID_md5WithRSA
NID_md5WithRSAEncryption
NID_md5_sha1
NID_mdc2
NID_mdc2WithRSA
NID_ms_code_com
NID_ms_code_ind
NID_ms_ctl_sign
NID_ms_efs
NID_ms_ext_req
NID_ms_sgc
NID_name
NID_netscape
NID_netscape_base_url
NID_netscape_ca_policy_url
NID_netscape_ca_revocation_url
NID_netscape_cert_extension
NID_netscape_cert_sequence
NID_netscape_cert_type
NID_netscape_comment
NID_netscape_data_type
NID_netscape_renewal_url
NID_netscape_revocation_url
NID_netscape_ssl_server_name
NID_ns_sgc
NID_organizationName
NID_organizationalUnitName
NID_pbeWithMD2AndDES_CBC
NID_pbeWithMD2AndRC2_CBC
NID_pbeWithMD5AndCast5_CBC
NID_pbeWithMD5AndDES_CBC
NID_pbeWithMD5AndRC2_CBC
NID_pbeWithSHA1AndDES_CBC
NID_pbeWithSHA1AndRC2_CBC
NID_pbe_WithSHA1And128BitRC2_CBC
NID_pbe_WithSHA1And128BitRC4
NID_pbe_WithSHA1And2_Key_TripleDES_CBC
NID_pbe_WithSHA1And3_Key_TripleDES_CBC
NID_pbe_WithSHA1And40BitRC2_CBC
NID_pbe_WithSHA1And40BitRC4
NID_pbes2
NID_pbmac1
NID_pkcs
NID_pkcs3
NID_pkcs7
NID_pkcs7_data
NID_pkcs7_digest
NID_pkcs7_encrypted
NID_pkcs7_enveloped
NID_pkcs7_signed
NID_pkcs7_signedAndEnveloped
NID_pkcs8ShroudedKeyBag
NID_pkcs9
NID_pkcs9_challengePassword
NID_pkcs9_contentType
NID_pkcs9_countersignature
NID_pkcs9_emailAddress
NID_pkcs9_extCertAttributes
NID_pkcs9_messageDigest
NID_pkcs9_signingTime
NID_pkcs9_unstructuredAddress
NID_pkcs9_unstructuredName
NID_private_key_usage_period
NID_rc2_40_cbc
NID_rc2_64_cbc
NID_rc2_cbc
NID_rc2_cfb64
NID_rc2_ecb
NID_rc2_ofb64
NID_rc4
NID_rc4_40
NID_rc5_cbc
NID_rc5_cfb64
NID_rc5_ecb
NID_rc5_ofb64
NID_ripemd160
NID_ripemd160WithRSA
NID_rle_compression
NID_rsa
NID_rsaEncryption
NID_rsadsi
NID_safeContentsBag
NID_sdsiCertificate
NID_secretBag
NID_serialNumber
NID_server_auth
NID_sha
NID_sha1
NID_sha1WithRSA
NID_sha1WithRSAEncryption
NID_shaWithRSAEncryption
NID_stateOrProvinceName
NID_subject_alt_name
NID_subject_key_identifier
NID_surname
NID_sxnet
NID_time_stamp
NID_title
NID_undef
NID_uniqueIdentifier
NID_x509Certificate
NID_x509Crl
NID_zlib_compression
OPENSSL_VERSION_NUMBER
OPENSSL_VERSION
OPENSSL_CFLAGS
OPENSSL_BUILT_ON
OPENSSL_PLATFORM
OPENSSL_DIR
OPENSSL_ENGINES_DIR
RSA_3
RSA_F4
SSL_CB_ACCEPT_EXIT
SSL_CB_ACCEPT_LOOP
SSL_CB_ALERT
SSL_CB_CONNECT_EXIT
SSL_CB_CONNECT_LOOP
SSL_CB_EXIT
SSL_CB_HANDSHAKE_DONE
SSL_CB_HANDSHAKE_START
SSL_CB_LOOP
SSL_CB_READ
SSL_CB_READ_ALERT
SSL_CB_WRITE
SSL_CB_WRITE_ALERT
SSL_ERROR_NONE
SSL_ERROR_SSL
SSL_ERROR_SYSCALL
SSL_ERROR_WANT_ACCEPT
SSL_ERROR_WANT_CONNECT
SSL_ERROR_WANT_READ
SSL_ERROR_WANT_WRITE
SSL_ERROR_WANT_X509_LOOKUP
SSL_ERROR_ZERO_RETURN
SSL_FILETYPE_ASN1
SSL_FILETYPE_PEM
SSL_F_CLIENT_CERTIFICATE
SSL_F_CLIENT_HELLO
SSL_F_CLIENT_MASTER_KEY
SSL_F_D2I_SSL_SESSION
SSL_F_GET_CLIENT_FINISHED
SSL_F_GET_CLIENT_HELLO
SSL_F_GET_CLIENT_MASTER_KEY
SSL_F_GET_SERVER_FINISHED
SSL_F_GET_SERVER_HELLO
SSL_F_GET_SERVER_VERIFY
SSL_F_I2D_SSL_SESSION
SSL_F_READ_N
SSL_F_REQUEST_CERTIFICATE
SSL_F_SERVER_HELLO
SSL_F_SSL_CERT_NEW
SSL_F_SSL_GET_NEW_SESSION
SSL_F_SSL_NEW
SSL_F_SSL_READ
SSL_F_SSL_RSA_PRIVATE_DECRYPT
SSL_F_SSL_RSA_PUBLIC_ENCRYPT
SSL_F_SSL_SESSION_NEW
SSL_F_SSL_SESSION_PRINT_FP
SSL_F_SSL_SET_FD
SSL_F_SSL_SET_RFD
SSL_F_SSL_SET_WFD
SSL_F_SSL_USE_CERTIFICATE
SSL_F_SSL_USE_CERTIFICATE_ASN1
SSL_F_SSL_USE_CERTIFICATE_FILE
SSL_F_SSL_USE_PRIVATEKEY
SSL_F_SSL_USE_PRIVATEKEY_ASN1
SSL_F_SSL_USE_PRIVATEKEY_FILE
SSL_F_SSL_USE_RSAPRIVATEKEY
SSL_F_SSL_USE_RSAPRIVATEKEY_ASN1
SSL_F_SSL_USE_RSAPRIVATEKEY_FILE
SSL_F_WRITE_PENDING
SSL_MIN_RSA_MODULUS_LENGTH_IN_BYTES
SSL_MODE_ENABLE_PARTIAL_WRITE
SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER
SSL_MODE_AUTO_RETRY
SSL_MODE_RELEASE_BUFFERS
SSL_NOTHING
SSL_OP_ALL
SSL_OP_ALLOW_UNSAFE_LEGACY_RENEGOTIATION
SSL_OP_ALLOW_NO_DHE_KEX
SSL_OP_CIPHER_SERVER_PREFERENCE
SSL_OP_CISCO_ANYCONNECT
SSL_OP_COOKIE_EXCHANGE
SSL_OP_CRYPTOPRO_TLSEXT_BUG
SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS
SSL_OP_ENABLE_MIDDLEBOX_COMPAT
SSL_OP_EPHEMERAL_RSA
SSL_OP_LEGACY_SERVER_CONNECT
SSL_OP_MICROSOFT_BIG_SSLV3_BUFFER
SSL_OP_MICROSOFT_SESS_ID_BUG
SSL_OP_MSIE_SSLV2_RSA_PADDING
SSL_OP_NETSCAPE_CA_DN_BUG
SSL_OP_NETSCAPE_CHALLENGE_BUG
SSL_OP_NETSCAPE_DEMO_CIPHER_CHANGE_BUG
SSL_OP_NETSCAPE_REUSE_CIPHER_CHANGE_BUG
SSL_OP_NON_EXPORT_FIRST
SSL_OP_NO_ANTI_REPLAY
SSL_OP_NO_COMPRESSION
SSL_OP_NO_CLIENT_RENEGOTIATION
SSL_OP_NO_ENCRYPT_THEN_MAC
SSL_OP_NO_QUERY_MTU
SSL_OP_NO_RENEGOTIATION
SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION
SSL_OP_NO_SSL_MASK
SSL_OP_NO_SSLv2
SSL_OP_NO_SSLv3
SSL_OP_NO_TICKET
SSL_OP_NO_TLSv1
SSL_OP_NO_TLSv1_1
SSL_OP_NO_TLSv1_2
SSL_OP_NO_TLSv1_3
SSL_OP_PKCS1_CHECK_1
SSL_OP_PKCS1_CHECK_2
SSL_OP_PRIORITIZE_CHACHA
SSL_OP_SAFARI_ECDHE_ECDSA_BUG
SSL_OP_SINGLE_DH_USE
SSL_OP_SINGLE_ECDH_USE
SSL_OP_SSLEAY_080_CLIENT_DH_BUG
SSL_OP_SSLREF2_REUSE_CERT_TYPE_BUG
SSL_OP_TLS_BLOCK_PADDING_BUG
SSL_OP_TLS_D5_BUG
SSL_OP_TLS_ROLLBACK_BUG
SSL_OP_TLSEXT_PADDING
SSL_READING
SSL_RECEIVED_SHUTDOWN
SSL_R_BAD_AUTHENTICATION_TYPE
SSL_R_BAD_CHECKSUM
SSL_R_BAD_MAC_DECODE
SSL_R_BAD_RESPONSE_ARGUMENT
SSL_R_BAD_SSL_FILETYPE
SSL_R_BAD_SSL_SESSION_ID_LENGTH
SSL_R_BAD_STATE
SSL_R_BAD_WRITE_RETRY
SSL_R_CHALLENGE_IS_DIFFERENT
SSL_R_CIPHER_TABLE_SRC_ERROR
SSL_R_INVALID_CHALLENGE_LENGTH
SSL_R_NO_CERTIFICATE_SET
SSL_R_NO_CERTIFICATE_SPECIFIED
SSL_R_NO_CIPHER_LIST
SSL_R_NO_CIPHER_MATCH
SSL_R_NO_PRIVATEKEY
SSL_R_NO_PUBLICKEY
SSL_R_NULL_SSL_CTX
SSL_R_PEER_DID_NOT_RETURN_A_CERTIFICATE
SSL_R_PEER_ERROR
SSL_R_PEER_ERROR_CERTIFICATE
SSL_R_PEER_ERROR_NO_CIPHER
SSL_R_PEER_ERROR_UNSUPPORTED_CERTIFICATE_TYPE
SSL_R_PUBLIC_KEY_ENCRYPT_ERROR
SSL_R_PUBLIC_KEY_IS_NOT_RSA
SSL_R_READ_WRONG_PACKET_TYPE
SSL_R_SHORT_READ
SSL_R_SSL_SESSION_ID_IS_DIFFERENT
SSL_R_UNABLE_TO_EXTRACT_PUBLIC_KEY
SSL_R_UNKNOWN_REMOTE_ERROR_TYPE
SSL_R_UNKNOWN_STATE
SSL_R_X509_LIB
SSL_SENT_SHUTDOWN
SSL_SESS_CACHE_OFF
SSL_SESS_CACHE_CLIENT
SSL_SESS_CACHE_SERVER
SSL_SESS_CACHE_BOTH
SSL_SESS_CACHE_NO_AUTO_CLEAR
SSL_SESS_CACHE_NO_INTERNAL_LOOKUP
SSL_SESS_CACHE_NO_INTERNAL_STORE
SSL_SESS_CACHE_NO_INTERNAL
SSL_SESSION_ASN1_VERSION
SSL_ST_ACCEPT
SSL_ST_BEFORE
SSL_ST_CONNECT
SSL_ST_INIT
SSL_ST_OK
SSL_ST_READ_BODY
SSL_ST_READ_HEADER
SSL_VERIFY_CLIENT_ONCE
SSL_VERIFY_FAIL_IF_NO_PEER_CERT
SSL_VERIFY_NONE
SSL_VERIFY_PEER
SSL_VERIFY_POST_HANDSHAKE
SSL_WRITING
SSL_X509_LOOKUP
SSL3_VERSION
SSLEAY_VERSION
SSLEAY_CFLAGS
SSLEAY_BUILT_ON
SSLEAY_PLATFORM
SSLEAY_DIR
X509_CHECK_FLAG_ALWAYS_CHECK_SUBJECT
X509_CHECK_FLAG_NEVER_CHECK_SUBJECT
X509_CHECK_FLAG_NO_WILDCARDS
X509_CHECK_FLAG_NO_PARTIAL_WILDCARDS
X509_CHECK_FLAG_MULTI_LABEL_WILDCARDS
X509_CHECK_FLAG_SINGLE_LABEL_SUBDOMAINS
X509_FILETYPE_ASN1
X509_FILETYPE_DEFAULT
X509_FILETYPE_PEM
X509_PURPOSE_ANY
X509_PURPOSE_CRL_SIGN
X509_PURPOSE_NS_SSL_SERVER
X509_PURPOSE_OCSP_HELPER
X509_PURPOSE_SMIME_ENCRYPT
X509_PURPOSE_SMIME_SIGN
X509_PURPOSE_SSL_CLIENT
X509_PURPOSE_SSL_SERVER
X509_PURPOSE_TIMESTAMP_SIGN
X509_TRUST_COMPAT
X509_TRUST_EMAIL
X509_TRUST_OBJECT_SIGN
X509_TRUST_OCSP_REQUEST
X509_TRUST_OCSP_SIGN
X509_TRUST_SSL_CLIENT
X509_TRUST_SSL_SERVER
X509_TRUST_TSA
X509_V_ERR_AKID_ISSUER_SERIAL_MISMATCH
X509_V_ERR_AKID_SKID_MISMATCH
X509_V_ERR_APPLICATION_VERIFICATION
X509_V_ERR_CA_KEY_TOO_SMALL
X509_V_ERR_CA_MD_TOO_WEAK
X509_V_ERR_CERT_CHAIN_TOO_LONG
X509_V_ERR_CERT_HAS_EXPIRED
X509_V_ERR_CERT_NOT_YET_VALID
X509_V_ERR_CERT_REJECTED
X509_V_ERR_CERT_REVOKED
X509_V_ERR_CERT_SIGNATURE_FAILURE
X509_V_ERR_CERT_UNTRUSTED
X509_V_ERR_CRL_HAS_EXPIRED
X509_V_ERR_CRL_NOT_YET_VALID
X509_V_ERR_CRL_PATH_VALIDATION_ERROR
X509_V_ERR_CRL_SIGNATURE_FAILURE
X509_V_ERR_DANE_NO_MATCH
X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT
X509_V_ERR_DIFFERENT_CRL_SCOPE
X509_V_ERR_EE_KEY_TOO_SMALL
X509_V_ERR_EMAIL_MISMATCH
X509_V_ERR_ERROR_IN_CERT_NOT_AFTER_FIELD
X509_V_ERR_ERROR_IN_CERT_NOT_BEFORE_FIELD
X509_V_ERR_ERROR_IN_CRL_LAST_UPDATE_FIELD
X509_V_ERR_ERROR_IN_CRL_NEXT_UPDATE_FIELD
X509_V_ERR_EXCLUDED_VIOLATION
X509_V_ERR_HOSTNAME_MISMATCH
X509_V_ERR_INVALID_CA
X509_V_ERR_INVALID_CALL
X509_V_ERR_INVALID_EXTENSION
X509_V_ERR_INVALID_NON_CA
X509_V_ERR_INVALID_POLICY_EXTENSION
X509_V_ERR_INVALID_PURPOSE
X509_V_ERR_IP_ADDRESS_MISMATCH
X509_V_ERR_KEYUSAGE_NO_CERTSIGN
X509_V_ERR_KEYUSAGE_NO_CRL_SIGN
X509_V_ERR_KEYUSAGE_NO_DIGITAL_SIGNATURE
X509_V_ERR_NO_EXPLICIT_POLICY
X509_V_ERR_NO_VALID_SCTS
X509_V_ERR_OCSP_CERT_UNKNOWN
X509_V_ERR_OCSP_VERIFY_FAILED
X509_V_ERR_OCSP_VERIFY_NEEDED
X509_V_ERR_OUT_OF_MEM
X509_V_ERR_PATH_LENGTH_EXCEEDED
X509_V_ERR_PATH_LOOP
X509_V_ERR_PERMITTED_VIOLATION
X509_V_ERR_PROXY_CERTIFICATES_NOT_ALLOWED
X509_V_ERR_PROXY_PATH_LENGTH_EXCEEDED
X509_V_ERR_PROXY_SUBJECT_NAME_VIOLATION
X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN
X509_V_ERR_STORE_LOOKUP
X509_V_ERR_SUBJECT_ISSUER_MISMATCH
X509_V_ERR_SUBTREE_MINMAX
X509_V_ERR_SUITE_B_CANNOT_SIGN_P_384_WITH_P_256
X509_V_ERR_SUITE_B_INVALID_ALGORITHM
X509_V_ERR_SUITE_B_INVALID_CURVE
X509_V_ERR_SUITE_B_INVALID_SIGNATURE_ALGORITHM
X509_V_ERR_SUITE_B_INVALID_VERSION
X509_V_ERR_SUITE_B_LOS_NOT_ALLOWED
X509_V_ERR_UNABLE_TO_DECODE_ISSUER_PUBLIC_KEY
X509_V_ERR_UNABLE_TO_DECRYPT_CERT_SIGNATURE
X509_V_ERR_UNABLE_TO_DECRYPT_CRL_SIGNATURE
X509_V_ERR_UNABLE_TO_GET_CRL
X509_V_ERR_UNABLE_TO_GET_CRL_ISSUER
X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT
X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY
X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE
X509_V_ERR_UNHANDLED_CRITICAL_CRL_EXTENSION
X509_V_ERR_UNHANDLED_CRITICAL_EXTENSION
X509_V_ERR_UNNESTED_RESOURCE
X509_V_ERR_UNSPECIFIED
X509_V_ERR_UNSUPPORTED_CONSTRAINT_SYNTAX
X509_V_ERR_UNSUPPORTED_CONSTRAINT_TYPE
X509_V_ERR_UNSUPPORTED_EXTENSION_FEATURE
X509_V_ERR_UNSUPPORTED_NAME_SYNTAX
X509_V_FLAG_ALLOW_PROXY_CERTS
X509_V_FLAG_CB_ISSUER_CHECK
X509_V_FLAG_CHECK_SS_SIGNATURE
X509_V_FLAG_CRL_CHECK
X509_V_FLAG_CRL_CHECK_ALL
X509_V_FLAG_EXPLICIT_POLICY
X509_V_FLAG_EXTENDED_CRL_SUPPORT
X509_V_FLAG_IGNORE_CRITICAL
X509_V_FLAG_INHIBIT_ANY
X509_V_FLAG_INHIBIT_MAP
X509_V_FLAG_NO_ALT_CHAINS
X509_V_FLAG_NO_CHECK_TIME
X509_V_FLAG_NOTIFY_POLICY
X509_V_FLAG_PARTIAL_CHAIN
X509_V_FLAG_POLICY_CHECK
X509_V_FLAG_POLICY_MASK
X509_V_FLAG_SUITEB_128_LOS
X509_V_FLAG_SUITEB_128_LOS_ONLY
X509_V_FLAG_SUITEB_192_LOS
X509_V_FLAG_TRUSTED_FIRST
X509_V_FLAG_USE_CHECK_TIME
X509_V_FLAG_USE_DELTAS
X509_V_FLAG_X509_STRICT
X509_V_OK
XN_FLAG_COMPAT
XN_FLAG_DN_REV
XN_FLAG_DUMP_UNKNOWN_FIELDS
XN_FLAG_FN_ALIGN
XN_FLAG_FN_LN
XN_FLAG_FN_MASK
XN_FLAG_FN_NONE
XN_FLAG_FN_OID
XN_FLAG_FN_SN
XN_FLAG_MULTILINE
XN_FLAG_ONELINE
XN_FLAG_RFC2253
XN_FLAG_SEP_COMMA_PLUS
XN_FLAG_SEP_CPLUS_SPC
XN_FLAG_SEP_MASK
XN_FLAG_SEP_MULTILINE
XN_FLAG_SEP_SPLUS_SPC
XN_FLAG_SPC_EQ
TLSEXT_STATUSTYPE_ocsp
TLS1_VERSION
TLS1_1_VERSION
TLS1_2_VERSION
TLS1_3_VERSION
OCSP_RESPONSE_STATUS_SUCCESSFUL
OCSP_RESPONSE_STATUS_MALFORMEDREQUEST
OCSP_RESPONSE_STATUS_INTERNALERROR
OCSP_RESPONSE_STATUS_TRYLATER
OCSP_RESPONSE_STATUS_SIGREQUIRED
OCSP_RESPONSE_STATUS_UNAUTHORIZED
V_OCSP_CERTSTATUS_GOOD
V_OCSP_CERTSTATUS_REVOKED
V_OCSP_CERTSTATUS_UNKNOWN
