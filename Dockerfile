# Rust base

FROM rust:1.71.1

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:17 ${JAVA_HOME} ${JAVA_HOME}

ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install Android utils

ENV ANDROID_HOME="/opt/android-sdk"

RUN mkdir -p ${ANDROID_HOME} \
  && cd ${ANDROID_HOME} \
  && curl https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -o sdk.zip \
  && unzip sdk.zip \
  && rm sdk.zip \
  && mv cmdline-tools latest \
  && mkdir cmdline-tools \
  && mv latest cmdline-tools/

ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

RUN yes | sdkmanager --licenses > /dev/null \
  && sdkmanager --install \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.2" \
    "ndk;25.2.9519653" \
    "cmake;3.22.1"

# Install required rust targets

RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
