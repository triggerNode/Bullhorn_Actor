FROM apify/actor-node-puppeteer-chrome:18

# Copy package files
COPY package*.json ./

# Install NPM packages, skip optional and development dependencies to keep the image small
RUN npm ci --omit=dev --omit=optional

# Copy source code to container
COPY . ./

# Run the application
CMD npm start 