FROM amazonlinux:2023

# Install required packages
RUN yum -y update && \
    yum -y install curl git tar gzip --allowerasing

# Install NVM (Node Version Manager)
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 9.11.2

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# Set PATH so that Node.js and npm are available
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Run the app
CMD ["npm", "start"]
