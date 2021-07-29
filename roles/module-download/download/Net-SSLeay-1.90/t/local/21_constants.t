# *** Automatically generated by helper_script/regen_openssl_constants.pl
# *** Do not edit manually!

use lib 'inc';

use Net::SSLeay;
use Test::Net::SSLeay;

eval "use Test::Exception;";
if ($@) {
    plan skip_all => 'Some tests need Test::Exception';
} else {
    plan tests => 553;
}

my @c = (qw/
 ASN1_STRFLGS_ESC_CTRL           NID_netscape                              R_UNKNOWN_REMOTE_ERROR_TYPE
 ASN1_STRFLGS_ESC_MSB            NID_netscape_base_url                     R_UNKNOWN_STATE
 ASN1_STRFLGS_ESC_QUOTE          NID_netscape_ca_policy_url                R_X509_LIB
 ASN1_STRFLGS_RFC2253            NID_netscape_ca_revocation_url            SENT_SHUTDOWN
 CB_ACCEPT_EXIT                  NID_netscape_cert_extension               SESSION_ASN1_VERSION
 CB_ACCEPT_LOOP                  NID_netscape_cert_sequence                SESS_CACHE_BOTH
 CB_ALERT                        NID_netscape_cert_type                    SESS_CACHE_CLIENT
 CB_CONNECT_EXIT                 NID_netscape_comment                      SESS_CACHE_NO_AUTO_CLEAR
 CB_CONNECT_LOOP                 NID_netscape_data_type                    SESS_CACHE_NO_INTERNAL
 CB_EXIT                         NID_netscape_renewal_url                  SESS_CACHE_NO_INTERNAL_LOOKUP
 CB_HANDSHAKE_DONE               NID_netscape_revocation_url               SESS_CACHE_NO_INTERNAL_STORE
 CB_HANDSHAKE_START              NID_netscape_ssl_server_name              SESS_CACHE_OFF
 CB_LOOP                         NID_ns_sgc                                SESS_CACHE_SERVER
 CB_READ                         NID_organizationName                      SSL3_VERSION
 CB_READ_ALERT                   NID_organizationalUnitName                SSLEAY_BUILT_ON
 CB_WRITE                        NID_pbeWithMD2AndDES_CBC                  SSLEAY_CFLAGS
 CB_WRITE_ALERT                  NID_pbeWithMD2AndRC2_CBC                  SSLEAY_DIR
 ERROR_NONE                      NID_pbeWithMD5AndCast5_CBC                SSLEAY_PLATFORM
 ERROR_SSL                       NID_pbeWithMD5AndDES_CBC                  SSLEAY_VERSION
 ERROR_SYSCALL                   NID_pbeWithMD5AndRC2_CBC                  ST_ACCEPT
 ERROR_WANT_ACCEPT               NID_pbeWithSHA1AndDES_CBC                 ST_BEFORE
 ERROR_WANT_CONNECT              NID_pbeWithSHA1AndRC2_CBC                 ST_CONNECT
 ERROR_WANT_READ                 NID_pbe_WithSHA1And128BitRC2_CBC          ST_INIT
 ERROR_WANT_WRITE                NID_pbe_WithSHA1And128BitRC4              ST_OK
 ERROR_WANT_X509_LOOKUP          NID_pbe_WithSHA1And2_Key_TripleDES_CBC    ST_READ_BODY
 ERROR_ZERO_RETURN               NID_pbe_WithSHA1And3_Key_TripleDES_CBC    ST_READ_HEADER
 EVP_PKS_DSA                     NID_pbe_WithSHA1And40BitRC2_CBC           TLS1_1_VERSION
 EVP_PKS_EC                      NID_pbe_WithSHA1And40BitRC4               TLS1_2_VERSION
 EVP_PKS_RSA                     NID_pbes2                                 TLS1_3_VERSION
 EVP_PKT_ENC                     NID_pbmac1                                TLS1_VERSION
 EVP_PKT_EXCH                    NID_pkcs                                  TLSEXT_STATUSTYPE_ocsp
 EVP_PKT_EXP                     NID_pkcs3                                 VERIFY_CLIENT_ONCE
 EVP_PKT_SIGN                    NID_pkcs7                                 VERIFY_FAIL_IF_NO_PEER_CERT
 EVP_PK_DH                       NID_pkcs7_data                            VERIFY_NONE
 EVP_PK_DSA                      NID_pkcs7_digest                          VERIFY_PEER
 EVP_PK_EC                       NID_pkcs7_encrypted                       VERIFY_POST_HANDSHAKE
 EVP_PK_RSA                      NID_pkcs7_enveloped                       V_OCSP_CERTSTATUS_GOOD
 FILETYPE_ASN1                   NID_pkcs7_signed                          V_OCSP_CERTSTATUS_REVOKED
 FILETYPE_PEM                    NID_pkcs7_signedAndEnveloped              V_OCSP_CERTSTATUS_UNKNOWN
 F_CLIENT_CERTIFICATE            NID_pkcs8ShroudedKeyBag                   WRITING
 F_CLIENT_HELLO                  NID_pkcs9                                 X509_CHECK_FLAG_ALWAYS_CHECK_SUBJECT
 F_CLIENT_MASTER_KEY             NID_pkcs9_challengePassword               X509_CHECK_FLAG_MULTI_LABEL_WILDCARDS
 F_D2I_SSL_SESSION               NID_pkcs9_contentType                     X509_CHECK_FLAG_NEVER_CHECK_SUBJECT
 F_GET_CLIENT_FINISHED           NID_pkcs9_countersignature                X509_CHECK_FLAG_NO_PARTIAL_WILDCARDS
 F_GET_CLIENT_HELLO              NID_pkcs9_emailAddress                    X509_CHECK_FLAG_NO_WILDCARDS
 F_GET_CLIENT_MASTER_KEY         NID_pkcs9_extCertAttributes               X509_CHECK_FLAG_SINGLE_LABEL_SUBDOMAINS
 F_GET_SERVER_FINISHED           NID_pkcs9_messageDigest                   X509_FILETYPE_ASN1
 F_GET_SERVER_HELLO              NID_pkcs9_signingTime                     X509_FILETYPE_DEFAULT
 F_GET_SERVER_VERIFY             NID_pkcs9_unstructuredAddress             X509_FILETYPE_PEM
 F_I2D_SSL_SESSION               NID_pkcs9_unstructuredName                X509_LOOKUP
 F_READ_N                        NID_private_key_usage_period              X509_PURPOSE_ANY
 F_REQUEST_CERTIFICATE           NID_rc2_40_cbc                            X509_PURPOSE_CRL_SIGN
 F_SERVER_HELLO                  NID_rc2_64_cbc                            X509_PURPOSE_NS_SSL_SERVER
 F_SSL_CERT_NEW                  NID_rc2_cbc                               X509_PURPOSE_OCSP_HELPER
 F_SSL_GET_NEW_SESSION           NID_rc2_cfb64                             X509_PURPOSE_SMIME_ENCRYPT
 F_SSL_NEW                       NID_rc2_ecb                               X509_PURPOSE_SMIME_SIGN
 F_SSL_READ                      NID_rc2_ofb64                             X509_PURPOSE_SSL_CLIENT
 F_SSL_RSA_PRIVATE_DECRYPT       NID_rc4                                   X509_PURPOSE_SSL_SERVER
 F_SSL_RSA_PUBLIC_ENCRYPT        NID_rc4_40                                X509_PURPOSE_TIMESTAMP_SIGN
 F_SSL_SESSION_NEW               NID_rc5_cbc                               X509_TRUST_COMPAT
 F_SSL_SESSION_PRINT_FP          NID_rc5_cfb64                             X509_TRUST_EMAIL
 F_SSL_SET_FD                    NID_rc5_ecb                               X509_TRUST_OBJECT_SIGN
 F_SSL_SET_RFD                   NID_rc5_ofb64                             X509_TRUST_OCSP_REQUEST
 F_SSL_SET_WFD                   NID_ripemd160                             X509_TRUST_OCSP_SIGN
 F_SSL_USE_CERTIFICATE           NID_ripemd160WithRSA                      X509_TRUST_SSL_CLIENT
 F_SSL_USE_CERTIFICATE_ASN1      NID_rle_compression                       X509_TRUST_SSL_SERVER
 F_SSL_USE_CERTIFICATE_FILE      NID_rsa                                   X509_TRUST_TSA
 F_SSL_USE_PRIVATEKEY            NID_rsaEncryption                         X509_V_ERR_AKID_ISSUER_SERIAL_MISMATCH
 F_SSL_USE_PRIVATEKEY_ASN1       NID_rsadsi                                X509_V_ERR_AKID_SKID_MISMATCH
 F_SSL_USE_PRIVATEKEY_FILE       NID_safeContentsBag                       X509_V_ERR_APPLICATION_VERIFICATION
 F_SSL_USE_RSAPRIVATEKEY         NID_sdsiCertificate                       X509_V_ERR_CA_KEY_TOO_SMALL
 F_SSL_USE_RSAPRIVATEKEY_ASN1    NID_secretBag                             X509_V_ERR_CA_MD_TOO_WEAK
 F_SSL_USE_RSAPRIVATEKEY_FILE    NID_serialNumber                          X509_V_ERR_CERT_CHAIN_TOO_LONG
 F_WRITE_PENDING                 NID_server_auth                           X509_V_ERR_CERT_HAS_EXPIRED
 GEN_DIRNAME                     NID_sha                                   X509_V_ERR_CERT_NOT_YET_VALID
 GEN_DNS                         NID_sha1                                  X509_V_ERR_CERT_REJECTED
 GEN_EDIPARTY                    NID_sha1WithRSA                           X509_V_ERR_CERT_REVOKED
 GEN_EMAIL                       NID_sha1WithRSAEncryption                 X509_V_ERR_CERT_SIGNATURE_FAILURE
 GEN_IPADD                       NID_shaWithRSAEncryption                  X509_V_ERR_CERT_UNTRUSTED
 GEN_OTHERNAME                   NID_stateOrProvinceName                   X509_V_ERR_CRL_HAS_EXPIRED
 GEN_RID                         NID_subject_alt_name                      X509_V_ERR_CRL_NOT_YET_VALID
 GEN_URI                         NID_subject_key_identifier                X509_V_ERR_CRL_PATH_VALIDATION_ERROR
 GEN_X400                        NID_surname                               X509_V_ERR_CRL_SIGNATURE_FAILURE
 LIBRESSL_VERSION_NUMBER         NID_sxnet                                 X509_V_ERR_DANE_NO_MATCH
 MBSTRING_ASC                    NID_time_stamp                            X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT
 MBSTRING_BMP                    NID_title                                 X509_V_ERR_DIFFERENT_CRL_SCOPE
 MBSTRING_FLAG                   NID_undef                                 X509_V_ERR_EE_KEY_TOO_SMALL
 MBSTRING_UNIV                   NID_uniqueIdentifier                      X509_V_ERR_EMAIL_MISMATCH
 MBSTRING_UTF8                   NID_x509Certificate                       X509_V_ERR_ERROR_IN_CERT_NOT_AFTER_FIELD
 MIN_RSA_MODULUS_LENGTH_IN_BYTES NID_x509Crl                               X509_V_ERR_ERROR_IN_CERT_NOT_BEFORE_FIELD
 MODE_ACCEPT_MOVING_WRITE_BUFFER NID_zlib_compression                      X509_V_ERR_ERROR_IN_CRL_LAST_UPDATE_FIELD
 MODE_AUTO_RETRY                 NOTHING                                   X509_V_ERR_ERROR_IN_CRL_NEXT_UPDATE_FIELD
 MODE_ENABLE_PARTIAL_WRITE       OCSP_RESPONSE_STATUS_INTERNALERROR        X509_V_ERR_EXCLUDED_VIOLATION
 MODE_RELEASE_BUFFERS            OCSP_RESPONSE_STATUS_MALFORMEDREQUEST     X509_V_ERR_HOSTNAME_MISMATCH
 NID_OCSP_sign                   OCSP_RESPONSE_STATUS_SIGREQUIRED          X509_V_ERR_INVALID_CA
 NID_SMIMECapabilities           OCSP_RESPONSE_STATUS_SUCCESSFUL           X509_V_ERR_INVALID_CALL
 NID_X500                        OCSP_RESPONSE_STATUS_TRYLATER             X509_V_ERR_INVALID_EXTENSION
 NID_X509                        OCSP_RESPONSE_STATUS_UNAUTHORIZED         X509_V_ERR_INVALID_NON_CA
 NID_ad_OCSP                     OPENSSL_BUILT_ON                          X509_V_ERR_INVALID_POLICY_EXTENSION
 NID_ad_ca_issuers               OPENSSL_CFLAGS                            X509_V_ERR_INVALID_PURPOSE
 NID_algorithm                   OPENSSL_DIR                               X509_V_ERR_IP_ADDRESS_MISMATCH
 NID_authority_key_identifier    OPENSSL_ENGINES_DIR                       X509_V_ERR_KEYUSAGE_NO_CERTSIGN
 NID_basic_constraints           OPENSSL_PLATFORM                          X509_V_ERR_KEYUSAGE_NO_CRL_SIGN
 NID_bf_cbc                      OPENSSL_VERSION                           X509_V_ERR_KEYUSAGE_NO_DIGITAL_SIGNATURE
 NID_bf_cfb64                    OPENSSL_VERSION_NUMBER                    X509_V_ERR_NO_EXPLICIT_POLICY
 NID_bf_ecb                      OP_ALL                                    X509_V_ERR_NO_VALID_SCTS
 NID_bf_ofb64                    OP_ALLOW_NO_DHE_KEX                       X509_V_ERR_OCSP_CERT_UNKNOWN
 NID_cast5_cbc                   OP_ALLOW_UNSAFE_LEGACY_RENEGOTIATION      X509_V_ERR_OCSP_VERIFY_FAILED
 NID_cast5_cfb64                 OP_CIPHER_SERVER_PREFERENCE               X509_V_ERR_OCSP_VERIFY_NEEDED
 NID_cast5_ecb                   OP_CISCO_ANYCONNECT                       X509_V_ERR_OUT_OF_MEM
 NID_cast5_ofb64                 OP_COOKIE_EXCHANGE                        X509_V_ERR_PATH_LENGTH_EXCEEDED
 NID_certBag                     OP_CRYPTOPRO_TLSEXT_BUG                   X509_V_ERR_PATH_LOOP
 NID_certificate_policies        OP_DONT_INSERT_EMPTY_FRAGMENTS            X509_V_ERR_PERMITTED_VIOLATION
 NID_client_auth                 OP_ENABLE_MIDDLEBOX_COMPAT                X509_V_ERR_PROXY_CERTIFICATES_NOT_ALLOWED
 NID_code_sign                   OP_EPHEMERAL_RSA                          X509_V_ERR_PROXY_PATH_LENGTH_EXCEEDED
 NID_commonName                  OP_LEGACY_SERVER_CONNECT                  X509_V_ERR_PROXY_SUBJECT_NAME_VIOLATION
 NID_countryName                 OP_MICROSOFT_BIG_SSLV3_BUFFER             X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN
 NID_crlBag                      OP_MICROSOFT_SESS_ID_BUG                  X509_V_ERR_STORE_LOOKUP
 NID_crl_distribution_points     OP_MSIE_SSLV2_RSA_PADDING                 X509_V_ERR_SUBJECT_ISSUER_MISMATCH
 NID_crl_number                  OP_NETSCAPE_CA_DN_BUG                     X509_V_ERR_SUBTREE_MINMAX
 NID_crl_reason                  OP_NETSCAPE_CHALLENGE_BUG                 X509_V_ERR_SUITE_B_CANNOT_SIGN_P_384_WITH_P_256
 NID_delta_crl                   OP_NETSCAPE_DEMO_CIPHER_CHANGE_BUG        X509_V_ERR_SUITE_B_INVALID_ALGORITHM
 NID_des_cbc                     OP_NETSCAPE_REUSE_CIPHER_CHANGE_BUG       X509_V_ERR_SUITE_B_INVALID_CURVE
 NID_des_cfb64                   OP_NON_EXPORT_FIRST                       X509_V_ERR_SUITE_B_INVALID_SIGNATURE_ALGORITHM
 NID_des_ecb                     OP_NO_ANTI_REPLAY                         X509_V_ERR_SUITE_B_INVALID_VERSION
 NID_des_ede                     OP_NO_CLIENT_RENEGOTIATION                X509_V_ERR_SUITE_B_LOS_NOT_ALLOWED
 NID_des_ede3                    OP_NO_COMPRESSION                         X509_V_ERR_UNABLE_TO_DECODE_ISSUER_PUBLIC_KEY
 NID_des_ede3_cbc                OP_NO_ENCRYPT_THEN_MAC                    X509_V_ERR_UNABLE_TO_DECRYPT_CERT_SIGNATURE
 NID_des_ede3_cfb64              OP_NO_QUERY_MTU                           X509_V_ERR_UNABLE_TO_DECRYPT_CRL_SIGNATURE
 NID_des_ede3_ofb64              OP_NO_RENEGOTIATION                       X509_V_ERR_UNABLE_TO_GET_CRL
 NID_des_ede_cbc                 OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION X509_V_ERR_UNABLE_TO_GET_CRL_ISSUER
 NID_des_ede_cfb64               OP_NO_SSL_MASK                            X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT
 NID_des_ede_ofb64               OP_NO_SSLv2                               X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY
 NID_des_ofb64                   OP_NO_SSLv3                               X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE
 NID_description                 OP_NO_TICKET                              X509_V_ERR_UNHANDLED_CRITICAL_CRL_EXTENSION
 NID_desx_cbc                    OP_NO_TLSv1                               X509_V_ERR_UNHANDLED_CRITICAL_EXTENSION
 NID_dhKeyAgreement              OP_NO_TLSv1_1                             X509_V_ERR_UNNESTED_RESOURCE
 NID_dnQualifier                 OP_NO_TLSv1_2                             X509_V_ERR_UNSPECIFIED
 NID_dsa                         OP_NO_TLSv1_3                             X509_V_ERR_UNSUPPORTED_CONSTRAINT_SYNTAX
 NID_dsaWithSHA                  OP_PKCS1_CHECK_1                          X509_V_ERR_UNSUPPORTED_CONSTRAINT_TYPE
 NID_dsaWithSHA1                 OP_PKCS1_CHECK_2                          X509_V_ERR_UNSUPPORTED_EXTENSION_FEATURE
 NID_dsaWithSHA1_2               OP_PRIORITIZE_CHACHA                      X509_V_ERR_UNSUPPORTED_NAME_SYNTAX
 NID_dsa_2                       OP_SAFARI_ECDHE_ECDSA_BUG                 X509_V_FLAG_ALLOW_PROXY_CERTS
 NID_email_protect               OP_SINGLE_DH_USE                          X509_V_FLAG_CB_ISSUER_CHECK
 NID_ext_key_usage               OP_SINGLE_ECDH_USE                        X509_V_FLAG_CHECK_SS_SIGNATURE
 NID_ext_req                     OP_SSLEAY_080_CLIENT_DH_BUG               X509_V_FLAG_CRL_CHECK
 NID_friendlyName                OP_SSLREF2_REUSE_CERT_TYPE_BUG            X509_V_FLAG_CRL_CHECK_ALL
 NID_givenName                   OP_TLSEXT_PADDING                         X509_V_FLAG_EXPLICIT_POLICY
 NID_hmacWithSHA1                OP_TLS_BLOCK_PADDING_BUG                  X509_V_FLAG_EXTENDED_CRL_SUPPORT
 NID_id_ad                       OP_TLS_D5_BUG                             X509_V_FLAG_IGNORE_CRITICAL
 NID_id_ce                       OP_TLS_ROLLBACK_BUG                       X509_V_FLAG_INHIBIT_ANY
 NID_id_kp                       READING                                   X509_V_FLAG_INHIBIT_MAP
 NID_id_pbkdf2                   RECEIVED_SHUTDOWN                         X509_V_FLAG_NOTIFY_POLICY
 NID_id_pe                       RSA_3                                     X509_V_FLAG_NO_ALT_CHAINS
 NID_id_pkix                     RSA_F4                                    X509_V_FLAG_NO_CHECK_TIME
 NID_id_qt_cps                   R_BAD_AUTHENTICATION_TYPE                 X509_V_FLAG_PARTIAL_CHAIN
 NID_id_qt_unotice               R_BAD_CHECKSUM                            X509_V_FLAG_POLICY_CHECK
 NID_idea_cbc                    R_BAD_MAC_DECODE                          X509_V_FLAG_POLICY_MASK
 NID_idea_cfb64                  R_BAD_RESPONSE_ARGUMENT                   X509_V_FLAG_SUITEB_128_LOS
 NID_idea_ecb                    R_BAD_SSL_FILETYPE                        X509_V_FLAG_SUITEB_128_LOS_ONLY
 NID_idea_ofb64                  R_BAD_SSL_SESSION_ID_LENGTH               X509_V_FLAG_SUITEB_192_LOS
 NID_info_access                 R_BAD_STATE                               X509_V_FLAG_TRUSTED_FIRST
 NID_initials                    R_BAD_WRITE_RETRY                         X509_V_FLAG_USE_CHECK_TIME
 NID_invalidity_date             R_CHALLENGE_IS_DIFFERENT                  X509_V_FLAG_USE_DELTAS
 NID_issuer_alt_name             R_CIPHER_TABLE_SRC_ERROR                  X509_V_FLAG_X509_STRICT
 NID_keyBag                      R_INVALID_CHALLENGE_LENGTH                X509_V_OK
 NID_key_usage                   R_NO_CERTIFICATE_SET                      XN_FLAG_COMPAT
 NID_localKeyID                  R_NO_CERTIFICATE_SPECIFIED                XN_FLAG_DN_REV
 NID_localityName                R_NO_CIPHER_LIST                          XN_FLAG_DUMP_UNKNOWN_FIELDS
 NID_md2                         R_NO_CIPHER_MATCH                         XN_FLAG_FN_ALIGN
 NID_md2WithRSAEncryption        R_NO_PRIVATEKEY                           XN_FLAG_FN_LN
 NID_md5                         R_NO_PUBLICKEY                            XN_FLAG_FN_MASK
 NID_md5WithRSA                  R_NULL_SSL_CTX                            XN_FLAG_FN_NONE
 NID_md5WithRSAEncryption        R_PEER_DID_NOT_RETURN_A_CERTIFICATE       XN_FLAG_FN_OID
 NID_md5_sha1                    R_PEER_ERROR                              XN_FLAG_FN_SN
 NID_mdc2                        R_PEER_ERROR_CERTIFICATE                  XN_FLAG_MULTILINE
 NID_mdc2WithRSA                 R_PEER_ERROR_NO_CIPHER                    XN_FLAG_ONELINE
 NID_ms_code_com                 R_PEER_ERROR_UNSUPPORTED_CERTIFICATE_TYPE XN_FLAG_RFC2253
 NID_ms_code_ind                 R_PUBLIC_KEY_ENCRYPT_ERROR                XN_FLAG_SEP_COMMA_PLUS
 NID_ms_ctl_sign                 R_PUBLIC_KEY_IS_NOT_RSA                   XN_FLAG_SEP_CPLUS_SPC
 NID_ms_efs                      R_READ_WRONG_PACKET_TYPE                  XN_FLAG_SEP_MASK
 NID_ms_ext_req                  R_SHORT_READ                              XN_FLAG_SEP_MULTILINE
 NID_ms_sgc                      R_SSL_SESSION_ID_IS_DIFFERENT             XN_FLAG_SEP_SPLUS_SPC
 NID_name                        R_UNABLE_TO_EXTRACT_PUBLIC_KEY            XN_FLAG_SPC_EQ

/);

my @missing;
my %h = map { $_=>1 } @Net::SSLeay::EXPORT_OK;

for (@c) {
  like(eval("&Net::SSLeay::$_; 'ok'") || $@, qr/^(ok|Your vendor has not defined SSLeay macro.*)$/, "$_");
  push(@missing, $_) unless $h{$_};
}

is(join(",", sort @missing), '', 'constants missing in @EXPORT_OK count='.scalar(@missing));

