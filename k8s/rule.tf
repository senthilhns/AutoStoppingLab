resource "kubectl_manifest" "rule" {
  yaml_body       = file("rule.yaml")
  validate_schema = false
}