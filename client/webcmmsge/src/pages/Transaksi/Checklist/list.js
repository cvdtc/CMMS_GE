import React, { Component } from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

class List extends Component {
    constructor(props) {
        super(props)
        this.state = {
            /// state load data checklist
            dataChecklist: '',
            /// flag for handlind data grid if false data grid hide 
            loadingChecklist: false,
            /// setate load data activity
            Activity: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "No. Dokumen",
                    field: 'no_dokumen',
                },
                {
                    headerName: "Deskripsi",
                    field: 'deskripsi',
                },
                {
                    headerName: "Tanggal",
                    field: 'tanggal_checklist',
                },
                {
                    headerName: "No. Mesin",
                    field: 'nomesin',
                },
                {
                    headerName: "Mesin",
                    field: 'ketmesin',
                },
                {
                    headerName: "Keterangan",
                    field: 'keterangan',
                },
                {
                    headerName: "Dikerjakan",
                    field: 'dikerjakan_oleh',
                }, 
                {
                    headerName: "Diperiksa",
                    field: 'diperiksa_oleh',
                },
                // {
                //     headerName: 'Action',
                //     editable: false,
                //     sortable: false,
                //     filter: false,
                //     floatingFilter: false,
                //     field: 'idmesin',
                //     cellRenderer: (params) => <div><button type='button' className='btn btn-success'>Ubah</button></div>
                // }
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

    componentDidMount() {
        this.loadDataChecklist()
    }

    /// getting data komponen from api with parameter idmesin
    async loadDataChecklist() {
        await axios.get("checklist", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ dataChecklist: response.data.data })
        }).catch((error) => {
            console.log(error)
        }).finally(() => {
        })
    }
    render() {
        return (
            <div>
                {/* /// navigation bar */}
                <NavbarComponent />
                {/* /// header form */}
                <h1>Data Checklist</h1>
                {/* /// condition to load data grid komponent */}
                
                    <div className='ag-theme-alpine' style={{ height: '100vh', width: '100vw' }}>
                        <AgGridReact
                            suppressExcelExport={true}
                            rowData={this.state.dataChecklist}
                            columnDefs={this.state.columnDefs}
                            gridOptions={this.state.gridOptions}
                            animateRows={true}
                            defaultColDef={this.state.defaultColDef}
                            loadingCellRendererParams={this.state.loadingCellRendererParams}
                        />
                    </div>
            </div>
        );
    }
}

export default List;
