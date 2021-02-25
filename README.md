# Humio for IBM Cloudpak Operator
Manages Humio Clusters integrated with IBM Cloudpak for Multicloud Management

## Installation
### Prerequisites
- OpenShift 4.6+
- IBM Cloudpak for Multicloud Management 2.3+
- A Kafka Installation or Strimzi Operator Installation Acessible from the cp4m namespace
- kubectl / oc
### Install the Humio Operator using the Helm Chart
1. Download the [Humio Operator Helm Chart](https://github.com/humio/humio-operator/tree/master/charts/humio-operator)
2. Install the Humio Operator via Helm 
```
helm install humio humio-operator/ --namespace cp4m --set installCRDs=true --set openshift=true --set certmanager=false
```
### Install the Humio for IBM Cloudpak Operator
1. Clone this repo
2. Switch to the `cp4m` namespace
```
oc project cp4m
```
3. Deploy the operator using the Make target
```
make deploy
```
### Create the truststore secret
Unless your cp-console ingress is secured using a certificate that is registered with a public CA, run this script to create a k8s secret containing a Java truststore containing the Cloudpak CA certificate for Humio to use
```
chmod +x create-truststore-secret.sh
./create-truststore-secret.sh
```
### Create the CloudPakHumioCluster Resource in the `cp4m` namespace
```
apiVersion: humio.partners.ibm.com/v1alpha1
kind: CloudPakHumioCluster
metadata:
  name: cphumio
  namespace: cp4m
spec:
  humioClusterSpec:
    image: "humio/humio-core:1.18.1"
    helperImage: "humio/humio-operator-helper:0.0.8"
    nodeCount: 3
    targetReplicationFactor: 3
    dataVolumePersistentVolumeClaimSpecTemplate:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Gi
# If using a preinstalled Kafka see https://github.com/humio/humio-operator/blob/master/config/samples/core_v1alpha1_humiocluster.yaml#L20
    environmentVariables: {}
  OidcUsernameClaim: "email"
  OidcGroupsClaim: "groupIds"
# Set to false if using a trusted certificate for your cp-console endpoint
  BedRockSelfSignedCert: true 
  strimzi:
# Set to true to create a Strimzi Kafka Cluster for Humio. Requires that Strimzi Operator be installed and watching the cp4m namespace
    createKafkaCluster: false 
# Set Strimzi Kafka spec here. See examples: https://github.com/strimzi/strimzi-kafka-operator/tree/master/examples/kafka
```
### Getting Started
1. Using the email address registered to your account in LDAP as the username (defaults to username@ibm.com if unspecified), grant yourself root access to Humio by following [these instructions](https://docs.humio.com/docs/security/root-access/#:~:text=Root%20users%20are%20users%20with,also%20members%20of%20all%20repositories.)
2. Login to the IBM Cloudpak for Multicloud Management UI and click `Humio` under the `Monitor health` section in the main menu
3. Follow [Humio docs](https://docs.humio.com/) to create repos and assign permissions to other users
