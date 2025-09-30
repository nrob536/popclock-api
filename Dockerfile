#FROM rstudio/plumber:latest

FROM rstudio/plumber:v1.1.0 

# Install system dependencies for R packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libsodium-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libuv1-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Relax warnings as errors
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
ENV CXXFLAGS="-O2 -Wall"

RUN mkdir -p ~/.R \
 && echo "CXXFLAGS += -O2 -Wall" > ~/.R/Makevars

# Install pak first
RUN R -e "install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')"

# Set pak as the default installer for renv
RUN R -e "options(renv.config.install.method = 'pak'); renv::restore(prompt = FALSE)"

EXPOSE 8000

# Use Rscript to run your entrypoint script
CMD ["Rscript", "run_api.R"]