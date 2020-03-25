require 'spec_helper'
require 'cfn-nag/custom_rules/EC2NetworkAclEntryReusedPortsRule'
require 'cfn-model'

describe EC2NetworkAclEntryReusedPortsRule do
  context 'EC2 Network ACLs reuse the same ports for 2 egress entries OR 2 ingress entries' do
    it 'returns the offending logical resource ids' do
      cfn_model = CfnParser.new.parse read_test_template(
        'yaml/ec2_networkaclentry/ec2_networkaclentry_reused_ports.yml'
      )

      actual_logical_resource_ids = EC2NetworkAclEntryReusedPortsRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[myNetworkAclEntry2 myNetworkAclEntry4]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end
  context 'EC2 Network ACLs reuse the same ports for 1 egress entry and 1 ingress entry' do
    it 'returns an empty list' do
      cfn_model = CfnParser.new.parse read_test_template(
        'yaml/ec2_networkaclentry/ec2_networkaclentry_egress_ingress_reused_ports.yml'
      )

      actual_logical_resource_ids = EC2NetworkAclEntryReusedPortsRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end
  context 'EC2 Network ACLs entries do not reuse ports' do
    it 'returns an empty list' do
      cfn_model = CfnParser.new.parse read_test_template(
        'yaml/ec2_networkaclentry/ec2_networkaclentry_no_reused_ports.yml'
      )

      actual_logical_resource_ids = EC2NetworkAclEntryReusedPortsRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end
end
