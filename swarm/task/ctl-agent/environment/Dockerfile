# UNTESTED DRAFT. Lean 4.36.0 + the Mathlib v4.36.0 build cache, baked in so agents never rebuild Mathlib.
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN useradd -m agent && mkdir -p /opt/mathlib-packages && chown agent /opt/mathlib-packages
USER agent
WORKDIR /home/agent
ENV PATH=/home/agent/.elan/bin:$PATH
RUN curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
      | sh -s -- -y --default-toolchain leanprover/lean4:v4.36.0
# Clone the public repo at a pinned commit only to resolve and cache Mathlib (~7 GB); agents work
# on the private HF mirror, never on GitHub. CTL_COMMIT = the main commit the mirror was seeded from.
ARG CTL_COMMIT=9a191bb
RUN git clone https://github.com/007vasy/constructor-theory-lean seed \
 && cd seed && git checkout ${CTL_COMMIT} \
 && lake exe cache get && lake build \
 && mv .lake/packages/* /opt/mathlib-packages/ \
 && cd .. && rm -rf seed
