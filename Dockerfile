FROM php:8.0.2-fpm
#for the arguments already defined in docker compose
ARG user
ARG uid
# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/
# Set working directory
WORKDIR /var/www


#to install dependacies
RUN apt-get update && apt-get install -y \
	build-essential -y  \
    libpng-dev  -y \
    libjpeg62-turbo-dev -y  \
    libfreetype6-dev -y  \
    locales -y  \
    zip -y  \
    jpegoptim optipng pngquant gifsicle -y  \
    vim -y  \
    unzip -y  \
    git -y  \
    curl -y 
	
#to clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# NOW LETS INSTALL COMPOSER
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Install extensions for php
# RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

 
# create system user to run composer and artisan commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user
# Add user for laravel application


# Copy existing application directory contents
COPY . /var/www
# Copy existing application directory permissions
# COPY --chown=www:www . /var/www

#set working directory
WORKDIR /var/www

USER $user

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]