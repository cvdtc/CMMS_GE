import React, { Component } from 'react';
import { Button, Col, Container, Row, Label, ButtonGroup } from 'reactstrap'

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

import { useNavigate } from "react-router-dom";

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

/// import axios 
import axios from '../../../utils/server';

/// action button per item
const actionButton = (params) => { console.log(params) }

class ListSite extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            /// modal handler show or hide
            showmodal: true,
            /// state for data site
            dataSite: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "Nama Site",
                    field: 'nama',
                },
                {
                    headerName: "Keterangan",
                    field: 'keterangan',
                },
                {
                    headerName: 'Action',
                    editable: false,
                    sortable: false,
                    filter: false,
                    floatingFilter: false,
                    field: 'idsite',
                    cellRenderer: (params) => <div><ButtonGroup>
                        <Button color='success' onClick={actionButton(params)}>Edit</Button>
                        <Button type="submit" color='danger'>Hapus</Button>
                    </ButtonGroup></div>
                }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: true,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }

    /// init state
    async componentDidMount() {
        await this.getDataSite()
    }

    /// getting data site from api
    async getDataSite() {
        this.setState({ loading: true })
        axios.get("site", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            // console.log(response.data.data);
            this.setState({ dataSite: response.data.data })
        }).catch((error) => {
            console.log(error)
        }).finally(() => {
            this.setState({ loading: false })
        })
    }

    // AddSite(e){
    //     e.preventDefault();
    // const history = useNavigate()
    //     history("/addsite");
    // }

    render() {
        return (
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                <Container fluid>
                    <Row>
                        <Label className='text-center text-md-right'><h1>Data Site</h1></Label>
                        <Col className='float-right'>
                            <Button className='float-right' color='primary'>Tambah Data</Button>
                        </Col>
                        <div className='ag-theme-alpine' style={{ height: '100vh', width: '100vw' }}>
                            <AgGridReact
                                suppressExcelExport={true}
                                rowData={this.state.dataSite}
                                columnDefs={this.state.columnDefs}
                                animateRows={true}
                                gridOptions={this.state.gridOptions}
                                defaultColDef={this.state.defaultColDef}
                                loadingCellRendererParams={this.state.loadingCellRendererParams}
                            />
                        </div>
                    </Row>
                </Container>
            </>
        );
    }

    // }
}

export default ListSite;
