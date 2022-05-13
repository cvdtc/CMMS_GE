import axios from 'axios';
const serverurl = axios.create({baseURL: 'http://crm.indahbp.id:9994/api/v1/'});
export default serverurl