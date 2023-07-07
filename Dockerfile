# Using official Rust Docker image for building the Rust app
FROM rust:bookworm as builder

WORKDIR /usr/src/rust-webserver-example

# Copy over code
COPY . .

# Build for release.
RUN cargo build --release

# Our Second stage, that creates the final minimal image
FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin

# Copy the binary from the builder stage
COPY --from=builder /usr/src/rust-webserver-example/target/release/rust-webserver-example .

# Command to run when starting the container
CMD ["./rust-webserver-example"]