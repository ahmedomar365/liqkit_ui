/// Default readiness signal. No-op on non-web platforms.
void setReadyFlag() {
  // Intentional no-op. Tests on the VM do not look for this flag.
}
