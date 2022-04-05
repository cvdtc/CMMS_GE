import React, { useState } from 'react';

/// import react router dom
// import { Link } from 'react-router-dom'
import { useNavigate } from "react-router-dom";

/// import reactstrap for form input design
import { Card, Col, Row, Form, FormGroup, Label, Input, Button, Container, ButtonGroup } from 'reactstrap'

/// import axios
import axios from "../../../utils/server";


const AddSite = () => {
    /// define form state
    const [nama, setNama] = useState("");
    const [keterangan, setKeterangan] = useState("");
    /// form validate
    const [validation, setValidation] = useState([]);
    /// previous page handler
    const history = useNavigate()
    /// post to api
    const sitePost = async (e) => {
        /// event handler
        e.preventDefault();
        /// initialize json value
        const dataSite = {
            nama: nama,
            keterangan: keterangan
        };
        /// sending data json to api
        await axios
            .post("site", dataSite, {
                headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
            })
            .then((response) => {
                setValidation("");
                history("/datasite");
            })
            .catch((error) => {
                /// if response fail will be catch error message
                setValidation(error.response.data);
            });
    };

    return (
        <Container fluid='md' className='mt-25'>
            <Row>
                <h3>Tambah Site</h3>
                <Form onSubmit={sitePost}>
                    <FormGroup>
                        <Card body>
                            <Label>Nama Site</Label>
                            <Input
                                type='text'
                                placeholder="nama site"
                                values={nama}
                                onChange={(e) => setNama(e.target.value)} />
                            <br />
                            <Label>Deskripsi Site</Label>
                            <Input
                                type='textarea'
                                placeholder="nama site"
                                values={keterangan}
                                onChange={(e) => setKeterangan(e.target.value)} />
                        </Card>
                    </FormGroup>
                    <Col md={{ offset: 9, size: 6 }} sm='12'>
                        <ButtonGroup>
                            <Button onClick={() => history.goBack()} color='danger'>Batal</Button>
                            <Button type="submit" color='primary'>Tambah Data</Button>
                        </ButtonGroup>

                        {/* <Link to='/datasite' className='btn btn-danger ml-2'>Batal</Link> */}
                    </Col>
                </Form>
            </Row>
        </Container>
    );
}

export default AddSite;
