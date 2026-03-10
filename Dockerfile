FROM ruby:3.2.2-slim

# Instalar dependências
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /app

# Copiar Gemfile
COPY Gemfile ./
RUN bundle install --without development test

# Copiar aplicação
COPY . .

# Precompilar assets
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Expor porta
EXPOSE 3000

# Comando padrão
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
