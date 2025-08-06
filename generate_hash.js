const bcrypt = require('bcryptjs');

async function generateHash() {
    const password = '123456';
    const saltRounds = 10;
    
    try {
        const salt = await bcrypt.genSalt(saltRounds);
        const hashedPassword = await bcrypt.hash(password, salt);
        
        console.log('Password:', password);
        console.log('Salt Rounds:', saltRounds);
        console.log('Generated Hash:', hashedPassword);
        console.log('\nYou can use this hash in your database for testing purposes.');
        
        // Verify the hash works
        const isMatch = await bcrypt.compare(password, hashedPassword);
        console.log('Hash verification:', isMatch ? 'SUCCESS' : 'FAILED');
        
    } catch (error) {
        console.error('Error generating hash:', error);
    }
}

generateHash(); 